//
//  TranslatedListModuleViewControllerProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol TranslatedListModuleViewOutputProtocol: class {
  func viewWillAppear()
  func deleteButtonPressed()
  func textInputInSearchBar(text: String)
  func searchingEnding()
  func rowSelected(with:TranslatedListCellModel)
}

protocol TranslatedListModuleViewInputProtocol: class {
  var output: TranslatedListModuleViewOutputProtocol {get set}
  func show(dictionary: [TranslatedListCellModel])
}
