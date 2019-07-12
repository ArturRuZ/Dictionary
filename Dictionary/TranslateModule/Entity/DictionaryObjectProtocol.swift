//
//  DictionaryObjectProtocol.swift
//  Dictionary
//
//  Created by Артур on 07/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol DictionaryObjectProtocol: class {
  var languageFrom: TranslationLanguages {get set}
  var languageTo: TranslationLanguages {get set}
  var textForTranslate: String {get set}
  var translatedText: String {get set}
  var time: Date? {get set}
  func changeLanguageDirection()
  func isDefault() -> Bool
  func getSupportedLanguages() -> [TranslationLanguages: String]
}
