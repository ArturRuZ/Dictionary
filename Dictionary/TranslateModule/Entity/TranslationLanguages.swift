//
//  TranslationLanguages.swift
//  Dictionary
//
//  Created by Артур on 07/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


enum TranslationLanguages: String {
  case ru = "ru"
  case en = "en"
  case fr = "fr"
  case es = "es"
}

let languagesDictionary: [TranslationLanguages: String] = [
  TranslationLanguages.ru: "Русский",
  TranslationLanguages.en: "English",
  TranslationLanguages.fr: "French",
  TranslationLanguages.es: "Spanish"
]
