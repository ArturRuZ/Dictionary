//
//  TranslatedObject.swift
//  Dictionary
//
//  Created by Артур on 08/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class TranslatedObject: TranslatedListCellModel {  
    var textForTranslate: String
    var translatedText: String
    var time: Date
  
  init(textForTranslate: String, translatedText: String, time: Date) {
    self.textForTranslate = textForTranslate
    self.translatedText = translatedText
    self.time = time
  }
  }

