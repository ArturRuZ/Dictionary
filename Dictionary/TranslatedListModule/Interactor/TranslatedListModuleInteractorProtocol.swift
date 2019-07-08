//
//  TranslatedListModuleInteractorProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol  TranslatedListModuleInteractorInputProtocol: class {
  var output: TranslatedListModuleInteractorOutputProtocol {get set}
  func downloadDictionaryHistory(with: ObjectSearchParametrs)
  func clearDictionary()
  func search(text: String)
}

protocol  TranslatedListModuleInteractorOutputProtocol: class {
  func prepared(dictionary: [TranslatedListCellModel])
}
