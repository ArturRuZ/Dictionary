//
//  DataBaseProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


enum ObjectSearchParametrs {
  case all
}

enum ObjectSaveParametrs {
  case tanslated (object: DictionaryObjectProtocol)
  case lastUsedLanguage (languageFrom: String, languageTo: String)
}
enum ObjectsList: String {
  case dictionaryHistory = "DictionaryHistory"
  case settings = "Settings"
}

protocol DataBaseProtocol: class {
  
  // MARK: - save methods rewrite objects wthit the same ID
  
  func saveObject(parametrs: ObjectSaveParametrs, completion: @escaping (Result<Void>) -> Void)
  func loadData<T>(with: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<[T]>) -> Void)
  func delete(with: ObjectSearchParametrs,inObjects: ObjectsList, completion: @escaping (Result<Void>) -> Void)
}
