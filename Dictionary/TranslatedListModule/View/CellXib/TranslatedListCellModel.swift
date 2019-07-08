//
//  TranslatedListCellModel.swift
//  Dictionary
//
//  Created by Артур on 07/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol TranslatedListCellModel {
  var textForTranslate: String {get}
  var translatedText: String {get}
  var time: Date {get set}
}
