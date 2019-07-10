//
//  DictionaryObject.swift
//  Dictionary
//
//  Created by Артур on 07/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class DictionaryObject: DictionaryObjectProtocol {
  private static let defaultForTranslateText = "Text for translate"
  private static let defaultTranslatedText = "Translated text"
  var languageFrom: TranslationLanguages
  var languageTo: TranslationLanguages
  var textForTranslate: String
  var translatedText: String
  var time: Date?
  
  init (languageFrom: TranslationLanguages, languageTo: TranslationLanguages, textForTranslate: String = defaultForTranslateText, translatedText: String = defaultTranslatedText, time: Date? = nil) {
    self.languageFrom = languageFrom
    self.languageTo = languageTo
    self.textForTranslate = textForTranslate
    self.translatedText =  translatedText
    self.time = time
  }
  
  func isDefault() -> Bool {
    if (self.textForTranslate == DictionaryObject.defaultForTranslateText) && (self.translatedText == DictionaryObject.defaultTranslatedText) {
      return true
    } else {
      return false
    }
  }
  
  func changeLanguageDirection() {
    let oldValueLanguage = self.languageTo
    self.languageTo = self.languageFrom
    self.languageFrom = oldValueLanguage
    if !self.isDefault() {
      let oldValuetranslatedText = self.translatedText
      self.translatedText = textForTranslate
      self.textForTranslate = oldValuetranslatedText
    }
  }
}
