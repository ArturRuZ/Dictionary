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
  
  weak var interactorOutput: TranslateModuleInteractorOutputProtocol!
  private let translateService: TranslateServiceProtocol
  private let dataBase: DataBaseProtocol
  
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
      DispatchQueue.main.async {
        let dictionaryObject = DictionaryObject(languageFrom: .en, languageTo: .ru)
        self.output.prepared(dictionaryObject: dictionaryObject)
      }
    }
  }
  
  func translate(data: DictionaryObjectProtocol) {
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
}

