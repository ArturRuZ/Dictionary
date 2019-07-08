//
//  DataBase.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation
import CoreData

final class DataBase: NSObject {
  
  // MARK: - Properties
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DataStorage")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error),\(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container
  }()
  
  // MARK: - Private Methods
  
  private func saveIn(context: NSManagedObjectContext) throws {
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    if context.hasChanges {
      try context.save()
      print("Saving Complete")
    }
  }
  private func getEntityDescription(fromEntity: ObjectsList, context: NSManagedObjectContext, completion: @escaping (Result<NSEntityDescription>) -> Void) {
    guard let entityDescription = NSEntityDescription.entity(forEntityName: "\(fromEntity.rawValue)", in: context)
      else {return completion(Result.error(ErrorsList.couldntInitEntity(": \(fromEntity.rawValue)")))}
    return completion(Result.success(entityDescription))
  }
  
  private func setupFetchRequest(inEntity: ObjectsList, byAttribute: String = "", forValue: String = "") -> NSFetchRequest<NSFetchRequestResult> {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(inEntity.rawValue)")
    if byAttribute != "" && forValue != "" {
      fetchRequest.predicate = NSPredicate(format: "\(byAttribute) = %@", "\(forValue)")
    }
    if inEntity.rawValue == ObjectsList.dictionaryHistory.rawValue {
      let sort = NSSortDescriptor(key: "time", ascending: true)
      fetchRequest.sortDescriptors = [sort]
    }
    fetchRequest.returnsObjectsAsFaults = false
    return fetchRequest
  }
}

// MARK: - DataBaseProtocol implementation

extension DataBase: DataBaseProtocol {
  
  // MARK: - saveObject DataBaseProtocol func
  
  func saveObject(parametrs: ObjectSaveParametrs, completion: @escaping (Result<Void>) -> Void) {
    switch parametrs {
    case .tanslated (let object):
      self.save(object: object) { result in
        guard let error = result.error else {return completion(Result.success(()))}
        completion(Result.error(error))
      }
    case .lastUsedLanguage(let languageFrom, let languageTo):
      self.save(languageFrom: languageFrom, languageTo: languageTo) { result in
        guard let error = result.error else {return completion(Result.success(()))}
        completion(Result.error(error))
      }
    }
  }
  
  // MARK: - loadObject DataBaseProtocol func
  
  func loadData<T>(with: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<[T]>) -> Void) {
    self.persistentContainer.performBackgroundTask {context in
      do {
        let objects: [T] = try self.findObjects(with: with,inObjects: inObjects, inContext: context)
        completion(Result.success(objects))
      } catch let error {
        completion(Result.error(error))
      }
    }
  }
  
  // MARK: - deleteObject DataBaseProtocol func
  
  func delete(with: ObjectSearchParametrs, inObjects: ObjectsList, completion: @escaping (Result<Void>) -> Void) {
    self.persistentContainer.performBackgroundTask {context in
      do {
        let objects: [NSManagedObject] = try self.findObjects(with: with, inObjects: inObjects, inContext: context)
        objects.forEach {context.delete($0)}
        try self.saveIn(context: context)
        completion(Result.success(()))
      } catch let error {
        completion(Result.error(error))
      }
    }
  }
  
  // MARK: - timerTask save private func
  
  private func save(object: DictionaryObjectProtocol, completion: @escaping (Result<Void>) -> Void) {
    self.persistentContainer.performBackgroundTask {context in
      self.getEntityDescription(fromEntity: .dictionaryHistory, context: context) {[weak self] result in
        guard let self = self else {return}
        guard let error = result.error else {
          let dictionaryHistory = DictionaryHistory(entity: result.success!, insertInto: context)
          dictionaryHistory.textForTranslate = object.textForTranslate
          dictionaryHistory.translatedText = object.translatedText
          dictionaryHistory.time = object.time as NSDate?
          do {
            try self.saveIn(context: context)
            completion(Result.success(()))
          } catch let error {completion(Result.error(error))}
          return
        }
        completion(Result.error(error))
      }
    }
  }
  
  private func save(languageFrom: String, languageTo: String, completion: @escaping (Result<Void>) -> Void) {
    self.persistentContainer.performBackgroundTask {context in
      self.getEntityDescription(fromEntity: .settings, context: context) {[weak self] result in
        guard let self = self else {return}
        guard let error = result.error else {
          let newSettings = Settings(entity: result.success!, insertInto: context)
          newSettings.id = "lastUsedLanguage"
          newSettings.lastLanguageFromTranslate = languageFrom
          newSettings.lastLanguageToTranslate = languageTo
          do {
            try self.saveIn(context: context)
            completion(Result.success(()))
          } catch let error {completion(Result.error(error))}
          return
        }
        completion(Result.error(error))
      }
    }
  }
  
  // MARK: - findObject private func
  
  private func findObjects<T>(with: ObjectSearchParametrs, inObjects: ObjectsList, inContext: NSManagedObjectContext) throws -> [T] {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    switch with {
    case .textForTranslate(let textForTranslate): fetchRequest = self.setupFetchRequest(inEntity: inObjects, byAttribute: "textForTranslate", forValue: "\(textForTranslate)")
    case .all:
      fetchRequest = self.setupFetchRequest(inEntity: inObjects, byAttribute: "", forValue: "")
    }
   
    guard fetchRequest != nil else {throw ErrorsList.fetchRequestBuildFailed("\(String(describing: fetchRequest))")}
    guard let findItems = try? inContext.fetch(fetchRequest!) as? [T] else {throw ErrorsList.couldntCastObjectToNecessaryType("\(T.self)")}
    return findItems
  }
}


