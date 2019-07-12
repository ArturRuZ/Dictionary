//
//  TranslateModuleInteractorProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit


protocol  TranslateModuleInteractorInputProtocol: class {
  var output: TranslateModuleInteractorOutputProtocol {get set}
  func translate(text: String)
  func prepareDictionaryObject()
  func changeLanguageDirection()
  func prepareChangeLanguageWindow(forTag: Int)
}

protocol  TranslateModuleInteractorOutputProtocol: class {
  func prepared(dictionaryObject: DictionaryObjectProtocol)
  func preparedChangeLanguage(window: UIAlertController)
}
