//
//  TranslateServiceMock.swift
//  DictionaryTests
//
//  Created by Артур on 16/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation
@testable import Dictionary

class TranslateServiceMock: TranslateServiceProtocol {
  func translateData<T>(fromURL: URL?, parseInto container: T.Type, completion: @escaping (Result<T>) -> Void) where T: Decodable, T: Encodable {
    guard let response = TranslationResponse(code: 200, text: ["Собака"]) as? T else {
      completion(Result(error: ErrorsList.errorData))
      return
    }
    completion(Result(value: response))
    }
  }
