//
//  DataBaseMock.swift
//  DictionaryTests
//
//  Created by Артур on 16/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation
@testable import Dictionary

class DataBaseMock: DataBaseProtocol {
  func saveObject(parametrs: ObjectSaveParametrs, completion: @escaping (Result<Void>) -> Void) {
  completion(Result(value: ()))
  }
  func loadData<T>(with parametrs: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<[T]>) -> Void) {
  completion(Result(value: []))
  }
  func delete(with parametrs: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<Void>) -> Void) {
  completion(Result(value: ()))
  }
}
