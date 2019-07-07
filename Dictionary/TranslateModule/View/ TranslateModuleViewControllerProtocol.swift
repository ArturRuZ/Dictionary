//
//   TranslateModuleViewControllerProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol TranslateModuleViewOutputProtocol: class {
  func endEditing(dictionaryObject: DictionaryObjectProtocol)
  func viewDidLoad()
}

protocol TranslateModuleViewInputProtocol: class {
  var output: TranslateModuleViewOutputProtocol {get set}
  func show(dictionaryObject: DictionaryObjectProtocol)
}

