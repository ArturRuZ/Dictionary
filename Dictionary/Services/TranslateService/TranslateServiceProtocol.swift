//
//  TranslateServiceProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


enum ErrorsList: Error {
  case urlIsIncorrect
  case errorData
  case translateIsCanceled
  case fetchRequestBuildFailed(_ :String)
  case couldntCastObjectToNecessaryType(_ :String)
  case couldntInitEntity(_ :String)
}


protocol TranslateServiceProtocol: class {
  func translateData<T>(fromURL: URL?, parseInto container: T.Type,completion: @escaping (Result<T>) -> Void) where T: Codable
}

