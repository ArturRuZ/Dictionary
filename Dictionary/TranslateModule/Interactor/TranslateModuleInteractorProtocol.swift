//
//  TranslateModuleInteractorProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol  TranslateModuleInteractorInputProtocol: class {
  var output: TranslateModuleInteractorOutputProtocol {get set}
  func translate(data: DictionaryObjectProtocol)
  func prepareDictionaryObject()
}

protocol  TranslateModuleInteractorOutputProtocol: class {
  func prepared(dictionaryObject: DictionaryObjectProtocol)
}
