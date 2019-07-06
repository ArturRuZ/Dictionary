//
//   TranslateModuleViewControllerProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


protocol TranslateModuleViewOutputProtocol: class {
  
}

protocol TranslateModuleViewInputProtocol: class {
  var output: TranslateModuleViewOutputProtocol {get set}
}

