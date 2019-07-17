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
  private func saveToBase(data: DictionaryObjectProtocol) {
    self.dataBase.saveObject(parametrs: .tanslated(object: data)) { result in
      if let error = result.error {
        print (error)
        DispatchQueue.main.async {
          self.interactorOutput.prepare(alert: self.createErrorWindow())
        }
      }
    }
  }
  private func saveToBase(languages fromData: DictionaryObjectProtocol) {
    let supportedLanguages = fromData.getSupportedLanguages()
    guard let languageTo = supportedLanguages[fromData.languageTo] else {return}
    guard let languageFrom = supportedLanguages[fromData.languageFrom] else {return}
    self.dataBase.saveObject(parametrs: .lastUsedLanguage(languageFrom: languageFrom, languageTo: languageTo )) { result in
      if let error = result.error {
        print (error)
        DispatchQueue.main.async {
          self.interactorOutput.prepare(alert: self.createErrorWindow())
        }
      }
    }
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
    dataBase.loadData(with: .all, inObjects: .settings) {(result: Result<[SettingsParams]>) in
      if let error = result.error {print (error)}
      let dictionaryObject = DictionaryObject()
      if result.success?.count != 0 {
        if let settings = result.success?[0] {
          let supportedLanguages = dictionaryObject.getSupportedLanguages()
          if let languageFrom = (supportedLanguages.filter { $0.value == "\(settings.languageFrom)" }).first?.key {dictionaryObject.languageFrom = languageFrom}
          if let languageTo = (supportedLanguages.filter { $0.value == "\(settings.languageTo)" }).first?.key {dictionaryObject.languageTo = languageTo}
        }
      }
      self.currentDictionaryObject = dictionaryObject
      DispatchQueue.main.async {
        self.interactorOutput.prepare(dictionaryObject: dictionaryObject)
      }
    }
  }
  func translate(text: String) {
    guard let currentDictionaryObject = self.currentDictionaryObject else {return}
    let textBeforeTranslate = currentDictionaryObject.textForTranslate
    print ("\(textBeforeTranslate)")
    currentDictionaryObject.textForTranslate = text
    if currentDictionaryObject.isDefault() {
      self.output.prepare(dictionaryObject: currentDictionaryObject)
      return
    }
    let url = self.buildUrlToTranslate(data: currentDictionaryObject)
    self.translateService.translateData(fromURL: url, parseInto: TranslationResponse.self, completion: { [weak self] result in
      guard let self = self else {return}
      guard let success = result.success else {
        if let error = result.error {print (error)} else {print("Unknown error")}
        DispatchQueue.main.async {
          self.interactorOutput.prepare(alert: self.createErrorWindow())
        }
        return
      }
      currentDictionaryObject.time = NSDate()
      currentDictionaryObject.translatedText = success.text[0]
      self.output.prepare(dictionaryObject: currentDictionaryObject)
      if currentDictionaryObject.textForTranslate != currentDictionaryObject.translatedText {
      self.saveToBase(data: currentDictionaryObject)
      }
      self.saveToBase(languages: currentDictionaryObject)
      }
    )}
  func changeLanguageDirection() {
    guard let currentDictionaryObject = self.currentDictionaryObject else {return}
    currentDictionaryObject.changeLanguageDirection()
    self.interactorOutput.prepare(dictionaryObject: currentDictionaryObject)
  }
  func createChangeLanguageWindow(forTag: Int) {
    var selectLanguage: TranslationLanguages?
    let alertController = UIAlertController(title: "Select language", message: "You can change language for translate", preferredStyle: .alert)
    for (key, value) in currentDictionaryObject?.getSupportedLanguages() ?? [:] {
      alertController.addAction(UIAlertAction(title: "\(value)", style: .default, handler: { [weak self] _ in
        guard let self = self else {return}
        selectLanguage = key
        guard let selectedLanguage = selectLanguage else {return}
        guard let currentDictionaryObject = self.currentDictionaryObject else {return}
        switch forTag {
        case 1: currentDictionaryObject.languageFrom = selectedLanguage
        case 2: currentDictionaryObject.languageTo = selectedLanguage
        default:
          break
        }
        currentDictionaryObject.isDefault() ? self.interactorOutput.prepare(dictionaryObject: currentDictionaryObject) : self.translate(text: currentDictionaryObject.textForTranslate)
      }))
    }
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    interactorOutput.prepare(alert: alertController)
  }
}
