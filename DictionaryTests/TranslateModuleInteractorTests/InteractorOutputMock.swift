//
//  InteractorOutputMock.swift
//  DictionaryTests
//
//  Created by Артур on 16/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit
@testable import Dictionary

class InteractorOutputMock: NSObject, TranslateModuleInteractorOutputProtocol, TranslateInteractorTestableProtocol {

  private var languageFrom: TranslationLanguages?
  private var languageTo: TranslationLanguages?
  @objc dynamic var isCreated = false
  @objc dynamic var isTranslated = false
  @objc dynamic var isLanguageChanged = false
  @objc dynamic var isAlertPrepared = false

  func prepare(dictionaryObject: DictionaryObjectProtocol) {
    if !self.isCreated {
      self.languageFrom = dictionaryObject.languageFrom
      self.languageTo = dictionaryObject.languageTo
      self.isCreated = true
    }
    if dictionaryObject.translatedText == "Собака" {isTranslated = true}
    if  self.languageFrom == dictionaryObject.languageTo && self.languageTo == dictionaryObject.languageFrom {
      self.isLanguageChanged = true
    }
  }
  func prepare(alert: UIAlertController) {
    isAlertPrepared = true
  }
}
