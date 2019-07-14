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
  func createDictionaryObject()
  func changeLanguageDirection()
  func createChangeLanguageWindow(forTag: Int)
}

protocol  TranslateModuleInteractorOutputProtocol: class {
  func prepare(dictionaryObject: DictionaryObjectProtocol)
  func prepare(alert: UIAlertController)
}
