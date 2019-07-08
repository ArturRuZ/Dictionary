//
//  DictionaryObject.swift
//  Dictionary
//
//  Created by Артур on 07/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class DictionaryObject: DictionaryObjectProtocol {
  var languageFrom: TranslationLanguages
  var languageTo: TranslationLanguages
  var textForTranslate: String
  var translatedText: String
  var time: Date?
  
  init (languageFrom: TranslationLanguages, languageTo: TranslationLanguages, textForTranslate: String, translatedText: String, time: Date?) {
    self.languageFrom = languageFrom
    self.languageTo = languageTo
    self.textForTranslate = textForTranslate
    self.translatedText =  translatedText
    self.time = time
  }
  
  func changeLanguageDirection() {
    let oldValueLanguage = self.languageTo
    self.languageTo = self.languageFrom
    self.languageFrom = oldValueLanguage
    if time != nil {
      let oldValuetranslatedText = self.translatedText
      self.translatedText = textForTranslate
      self.textForTranslate = oldValuetranslatedText
    }
  }
}
