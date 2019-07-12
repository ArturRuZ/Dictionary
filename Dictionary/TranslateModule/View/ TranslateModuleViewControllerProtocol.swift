//
//   TranslateModuleViewControllerProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit


protocol TranslateModuleViewOutputProtocol: class {
  func endEditing(text: String)
  func viewDidLoad()
  func changelanguageButtonPressed(withTag: Int)
  func changelanguageDitrectionButtonPressed()
}

protocol TranslateModuleViewInputProtocol: class {
  var output: TranslateModuleViewOutputProtocol {get set}
  func show(dictionaryObject: DictionaryObjectProtocol)
  func showChangeLanguage(window: UIAlertController)
}

