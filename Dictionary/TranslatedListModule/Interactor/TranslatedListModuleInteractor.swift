//
//  TranslatedListModuleInteractor.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class TranslatedListModuleInteractor {
  
  // MARK: - Properties
  
  weak var interactorOutput: TranslatedListModuleInteractorOutputProtocol!
  private let dataBase: DataBaseProtocol
  
  // MARK: - Initialization
  
  init( dataBase: DataBaseProtocol) {
    self.dataBase = dataBase
  }
}

// MARK: - TranslatedListModuleInteractorInputProtocol implementation

extension TranslatedListModuleInteractor: TranslatedListModuleInteractorInputProtocol {
  var output: TranslatedListModuleInteractorOutputProtocol {
    get {
      return interactorOutput
    }
    set {
      interactorOutput = newValue
    }
  }
  func downloadDictionaryHistory(with: ObjectSearchParametrs) {
    dataBase.loadData(with: with, inObjects: .dictionaryHistory) {(result: Result<[TranslatedObject]>) in
      if let error = result.error {print (error)}
      guard let dictionaryHistory = result.success else {return}
      DispatchQueue.main.async {
        self.interactorOutput.prepared(dictionary: dictionaryHistory)
      }
    }
  }
  
  func clearDictionary() {
    self.dataBase.delete(with: .all, inObjects: .dictionaryHistory) { result in
      if let error = result.error {print (error)}
      let translatedWords: [TranslatedListCellModel] = []
      DispatchQueue.main.async {
        self.interactorOutput.prepared(dictionary: translatedWords)
      }
    }
  }
  func search(text: String) {
    downloadDictionaryHistory(with: .textForTranslate(textForTranslate: text))
  }
}



