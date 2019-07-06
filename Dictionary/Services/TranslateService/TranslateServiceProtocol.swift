//
//  TranslateServiceProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


enum translationLanguages: String {
  case ru = "ru"
  case en = "en"
  case fr = "fr"
  case es = "es"
  
}

enum ErrorsList: Error {
  case urlIsIncorrect
  case errorData
  case translateIsCanceled
  case timeout
}


protocol TranslateServiceProtocol: class {
  func loadData<T>(fromURL: URL?,
                   parseInto container: T.Type,
                   success: @escaping (T) -> Void,
                   failure: @escaping (Error) -> Void) where T : Codable 
}

