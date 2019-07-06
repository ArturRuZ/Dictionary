//
//  TranslatedListModulePresenterProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol TranslatedListModulePresenterInputProtocol: class {
  var delegate: TranslatedListModulePresenterDelegateProtocol {get set}
  var input: TranslatedListModuleInteractorInputProtocol {get set}
  var output: TranslatedListModuleViewInputProtocol {get set}
}
protocol TranslatedListModulePresenterDelegateProtocol: class {}

