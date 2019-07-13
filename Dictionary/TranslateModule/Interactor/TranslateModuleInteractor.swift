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
  
  private func buildUrlToTranslate(data: DictionaryObjectProtocol) -> URL? {
    guard let plist = Bundle.main.url(forResource: "TranslateApiUrl", withExtension: "plist"),
      let contents = try? Data(contentsOf: plist),
      let serialization = try? PropertyListSerialization.propertyList(from: contents, format: nil),
      let firstPartUrl = serialization as? [String] else {
        print("Can't import url from plist")
        return nil
    }
    guard let encodedText = data.textForTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
      print("Can't encode text")
      return nil
    }
    let url = firstPartUrl[0] + "&text=\(encodedText)" + "&lang=\(data.languageFrom)-\(data.languageTo)"
    return URL(string: url)
  }
  private func createErrorWindow() -> UIAlertController {
    let alertController = UIAlertController(title: "Error", message: "Sorry, you catched a bag", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK :[", style: .cancel, handler: nil))
    return alertController
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
  func createDictionaryObject() {
    dataBase.loadData(with: .all, inObjects: .settings) {(result: Result<[Settings]>) in
      if let error = result.error {print (error)
      }
      //guard let settings = result.success?[0] else {return}
      let dictionaryObject = DictionaryObject(languageFrom: .en, languageTo: .ru)
      self.currentDictionaryObject = dictionaryObject
      DispatchQueue.main.async {
        
        self.output.prepare(dictionaryObject: dictionaryObject)
      }
    }
  }
  func translate(text: String) {
    guard let data = currentDictionaryObject else {return}
    data.textForTranslate = text
    let url = self.buildUrlToTranslate(data: data)
    self.translateService.translateData(fromURL: url, parseInto: TranslationResponse.self, completion: { [weak self] result in
      guard let self = self else {return}
      guard let success = result.success else {
        if let error = result.error {print (error)} else {print("Unknown error")}
        DispatchQueue.main.async {
          self.interactorOutput.prepareWindow(alert: self.createErrorWindow())
        }
        return
      }
      data.time = NSDate()
      data.translatedText = success.text[0]
      self.output.prepare(dictionaryObject: data)
      self.dataBase.saveObject(parametrs: .tanslated(object: data)) { result in
        if let error = result.error {
          print (error)
          DispatchQueue.main.async {
            self.interactorOutput.prepareWindow(alert: self.createErrorWindow())
          }
        }
      }
      self.dataBase.saveObject(parametrs: .lastUsedLanguage(languageFrom: data.languageFrom.rawValue, languageTo: data.languageTo.rawValue)) { result in
        if let error = result.error {
          print (error)
          DispatchQueue.main.async {
            self.interactorOutput.prepareWindow(alert: self.createErrorWindow())
          }
        }
      }
      }
    )}
  func changeLanguageDirection() {
    guard let object = currentDictionaryObject else {return}
    object.changeLanguageDirection()
    object.isDefault() ? self.output.prepare(dictionaryObject: object) : self.translate(text: object.textForTranslate)
  }
  func createChangeLanguageWindow(forTag: Int) {
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
        self.translate(text: self.currentDictionaryObject!.textForTranslate)
      }))
    }
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    interactorOutput.prepareWindow(alert: alertController)
  }
}

