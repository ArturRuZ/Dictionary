//
//  TranslateServiceMock.swift
//  DictionaryTests
//
//  Created by Артур on 16/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation
@testable import Dictionary

struct SuccessResponseMock: Codable {
  var code = 200
  var text = ["Собака"]
}
struct UnSuccessResponseMock: Codable {
  var code = 404
  var text: [String] = []
}
struct EmptyResponseMock: Codable {
  var code = 200
  var text: [String] = []
}
class TranslateServiceMock: TranslateServiceProtocol {
  func translateData<T>(fromURL: URL?, parseInto container: T.Type, completion: @escaping (Result<T>) -> Void) where T: Decodable, T: Encodable {
    guard let response = TranslationResponse(code: 200, text: []) as? T else {
      completion(Result(error: ErrorsList.errorData))
      return
    }
    completion(Result(value: response))
    }
  }
