//
//  TranslateModuleInteractor.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class TranslateModuleInteractor {
  
    // MARK: - Properties
  
  var interactorOutput: TranslateModuleInteractorOutputProtocol!
  private let translateService: TranslateServiceProtocol
  private let dataBase: DataBaseProtocol
  private let defaultForTranslateText = "Text for translate"
  private let defaultTranslatedText = "Translated text"
  
  init(translateService: TranslateServiceProtocol, dataBase: DataBaseProtocol) {
    self.translateService = translateService
    self.dataBase = dataBase
  }
  
    // MARK: - Private methods
  
  private func buildUrlToTranslate(from: DictionaryObjectProtocol) -> URL? {
    let correctTextForTranslate = from.textForTranslate.replacingOccurrences(of: " ", with: "%20")
    guard let encodedUrl = correctTextForTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return nil}
    let url = "https://api.multillect.com/translate/json/1.0/1165?method=translate/api/translate&from=\(from.languageFrom)&to=\(from.languageTo)&text=\(encodedUrl)&sig=ac0089a730c066aea5a03168bbac6fd7"
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
    let object = DictionaryObject(languageFrom: .en, languageTo: .ru, textForTranslate: defaultForTranslateText, translatedText: defaultTranslatedText, time: nil)
    output.prepared(dictionaryObject: object)
  }
  
  func translate(data: DictionaryObjectProtocol) {
    let url = self.buildUrlToTranslate(from: data)
    self.translateService.translateData(fromURL: url, parseInto: TranslationResponse.self, completion: {[weak self](result, error) in
      guard let self = self else {return}
      if let error = error {print (error)} else {
        guard let removedLastSpace = result?.result.translated?.dropLast() else {return}
        data.translatedText = String(removedLastSpace)
        data.time = self.convertTime(time: result?.timestamp ?? 0)
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
}

