//
//  TranslateModuleInteractor.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit


final class TranslateModuleInteractor {
  
  // MARK: - Properties
  
  weak var interactorOutput: TranslateModuleInteractorOutputProtocol!
  private let translateService: TranslateServiceProtocol
  private let dataBase: DataBaseProtocol
  private var currentDictionaryObject: DictionaryObjectProtocol?
  
  // MARK: - Initialization
  
  init(translateService: TranslateServiceProtocol, dataBase: DataBaseProtocol) {
    self.translateService = translateService
    self.dataBase = dataBase
  }
  
  // MARK: - Private methods
  
  private func buildUrlToTranslate(from: DictionaryObjectProtocol) -> URL? {
    let correctTextForTranslate = from.textForTranslate.replacingOccurrences(of: " ", with: "%20")
    guard let encodedUrl = correctTextForTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return nil}
    let url = "https://api.multillect.com/translate/json/1.0/1165?method=translate/api/translate&from=\(from.languageFrom)&to=\(from.languageTo)&text=\(encodedUrl)&sig=ac0089a730c066aea5a03168bbac6fd7"
   print (url)
    return URL(string: url)
  }
  private func convertTime(time: Int)-> Date? {
    let date = Date(timeIntervalSince1970: TimeInterval(time) )
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd YYYY HH:mm"
    dateFormatter.locale = Locale(identifier: "ru_RU")
    let dateString = dateFormatter.string(from: date)
    guard let convertedDate = dateFormatter.date(from: dateString) else {return nil}
    return convertedDate
  }
}

// MARK: - TranslateModuleInteractorInputProtocol implementation

extension TranslateModuleInteractor: TranslateModuleInteractorInputProtocol {
  var output: TranslateModuleInteractorOutputProtocol {
    get {
      return interactorOutput
    }
    set {
      interactorOutput = newValue
    }
  }
  
  func prepareDictionaryObject() {
    dataBase.loadData(with: .all, inObjects: .settings) {(result: Result<[Settings]>) in
      if let error = result.error {print (error)}
      //guard let settings = result.success?[0] else {return}
      let dictionaryObject = DictionaryObject(languageFrom: .en, languageTo: .ru)
      self.currentDictionaryObject = dictionaryObject
      DispatchQueue.main.async {
        self.output.prepared(dictionaryObject: dictionaryObject)
      }
    }
  }
  func translate(text: String) {
    guard let data = currentDictionaryObject else {return}
    data.textForTranslate = text
    let url = self.buildUrlToTranslate(from: data)
    self.translateService.translateData(fromURL: url, parseInto: TranslationResponse.self, completion: {[weak self] result in
      guard let self = self else {return}
      if let error = result.error {print (error)} else {
        guard let removedLastSpace = result.success?.result.translated?.dropLast() else {return}
        data.translatedText = String(removedLastSpace)
        data.time = self.convertTime(time: result.success?.timestamp ?? 0)
        self.output.prepared(dictionaryObject: data)
        self.dataBase.saveObject(parametrs: .tanslated(object: data)) { result in
          if let error = result.error {print (error)}
        }
        self.dataBase.saveObject(parametrs: .lastUsedLanguage(languageFrom: data.languageFrom.rawValue, languageTo: data.languageTo.rawValue)) { result in
          if let error = result.error {print (error)}
        }
      }
      }
    )}
  func changeLanguageDirection() {
    guard let object = currentDictionaryObject else {return}
    object.changeLanguageDirection()
    self.output.prepared(dictionaryObject: object)
  }
  func prepareChangeLanguageWindow(forTag: Int) {
        var selectLanguage: TranslationLanguages?
        let alertController = UIAlertController(title: "Select language", message: "You can change language for translate", preferredStyle: .alert)
    for (key, value) in currentDictionaryObject?.getSupportedLanguages() ?? [:] {
          alertController.addAction(UIAlertAction(title: "\(value)", style: .default, handler: { [weak self] _ in
            guard let self = self else {return}
            selectLanguage = key
            guard let selectedLanguage = selectLanguage else {return}
            guard self.currentDictionaryObject != nil else {return}
            switch forTag {
            case 1: self.currentDictionaryObject?.languageFrom = selectedLanguage
            case 2: self.currentDictionaryObject?.languageTo = selectedLanguage
            default:
              break
            }
            self.interactorOutput.prepared(dictionaryObject: self.currentDictionaryObject!)
          }))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        interactorOutput.preparedChangeLanguage(window: alertController)
  }
}

