//
//  DataBaseClient.swift
//  Dictionary
//
//  Created by Артур on 13/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class DataBaseClient: DataBaseProtocol {
  
  //MARK - Properties
  
  private let dataBase: DataBaseProtocol
  
  //MARK - Initialization
  
  init(database: DataBaseProtocol) {
    self.dataBase = database
  }
  
  //MARK - DataBaseProtocol methods implementation
  
  func saveObject(parametrs: ObjectSaveParametrs, completion: @escaping (Result<Void>) -> Void) {
    self.dataBase.saveObject(parametrs: parametrs, completion: completion)
  }
  
  func loadData<T>(with parametrs: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<[T]>) -> Void) {
    self.dataBase.loadData(with: parametrs, inObjects: inObjects) {(result: Result<[Any]>) in
      var objectsFromBase: [Any] = []
      var convertedObjects: [T] = []
      switch result {
      case .success(let value):
        objectsFromBase = value
      case .error(let error):
        completion(Result(error:error))
      }
      if objectsFromBase.count == 0 {completion(Result(error: ErrorsList.obgectsNoFound))}
      for object in objectsFromBase {
        switch T.self {
        case is TranslatedObject.Type:
          guard let downloadedObject = object as? DictionaryHistory else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          guard let textForTranslate = downloadedObject.textForTranslate else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          guard let translatedText = downloadedObject.translatedText else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          guard let time = downloadedObject.time else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          let newTranslatedObject = TranslatedObject(textForTranslate: textForTranslate, translatedText: translatedText, time: time)
          guard let convertedObject = newTranslatedObject as? T else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          convertedObjects.append(convertedObject)
          completion(Result(value: convertedObjects))
        default:
          completion(Result(error: ErrorsList.noSuchTypeForDownload))
        }
      }
    }
  }
  func delete(with parametrs: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<Void>) -> Void) {
    self.dataBase.delete(with: parametrs, inObjects: inObjects, completion: completion)
  }
}
