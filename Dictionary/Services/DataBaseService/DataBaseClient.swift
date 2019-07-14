//
//  DataBaseClient.swift
//  Dictionary
//
//  Created by Артур on 13/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation

final class DataBaseClient: DataBaseProtocol {

  // MARK: - Properties

  private let dataBase: DataBaseProtocol

  // MARK: - Initialization

  init(database: DataBaseProtocol) {
    self.dataBase = database
  }

  // MARK: - Private methods

  private func convert(from data: DictionaryHistory) -> TranslatedObject? {
    guard let textForTranslate = data.textForTranslate else {return nil}
    guard let translatedText = data.translatedText else {return nil}
    guard let time = data.time else {return nil}
    let newTranslatedObject = TranslatedObject(textForTranslate: textForTranslate, translatedText: translatedText, time: time)
    return newTranslatedObject
  }
  private func convert(from data: Settings) -> SettingsParams? {
    guard let lastLanguageFromTranslate = data.lastLanguageFromTranslate else {return nil}
    guard let lastLanguageToTranslate = data.lastLanguageToTranslate else {return nil}
    let newSettingsParams = SettingsParams(languageFrom: lastLanguageFromTranslate, languageTo: lastLanguageToTranslate)
    return newSettingsParams
  }

  // MARK: - DataBaseProtocol methods implementation

  func saveObject(parametrs: ObjectSaveParametrs, completion: @escaping (Result<Void>) -> Void) {
    self.dataBase.saveObject(parametrs: parametrs, completion: completion)
  }
  func loadData<T>(with parametrs: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<[T]>) -> Void) {
    self.dataBase.loadData(with: parametrs, inObjects: inObjects) { [weak self] (result: Result<[Any]>) in
      guard let self = self else {return}
      var objectsFromBase: [Any] = []
      var convertedObjects: [T] = []
      switch result {
      case .success(let value):
        objectsFromBase = value
      case .error(let error):
        completion(Result(error: error))
      }
      if objectsFromBase.count == 0 {completion(Result(error: ErrorsList.obgectsNoFound))}
      for object in objectsFromBase {
        switch T.self {
        case is TranslatedObject.Type:
          guard let downloadedObject = object as? DictionaryHistory else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          guard let newTranslatedObject = self.convert(from: downloadedObject) else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          guard let convertedObject = newTranslatedObject as? T else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          convertedObjects.append(convertedObject)
        case is SettingsParams.Type:
          guard let downloadedObject = object as? Settings else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          guard let newSettingsParams  = self.convert(from: downloadedObject) else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          guard let convertedObject = newSettingsParams as? T else {
            return completion(Result(error: ErrorsList.coudntConvertObject))
          }
          convertedObjects.append(convertedObject)
        default:
          completion(Result(error: ErrorsList.noSuchTypeForDownload))
        }
      }
      completion(Result(value: convertedObjects))
    }
  }
  func delete(with parametrs: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<Void>) -> Void) {
    self.dataBase.delete(with: parametrs, inObjects: inObjects, completion: completion)
  }
}
