//
//  TranslateModulePresenterProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation

protocol TranslateModulePresenterInputProtocol: class {
  var delegate: TranslateModulePresenterDelegateProtocol {get set}
  var input: TranslateModuleInteractorInputProtocol {get set}
  var output: TranslateModuleViewInputProtocol {get set}
  func show(translatefor: DictionaryObjectProtocol)
}
protocol TranslateModulePresenterDelegateProtocol: class {}
