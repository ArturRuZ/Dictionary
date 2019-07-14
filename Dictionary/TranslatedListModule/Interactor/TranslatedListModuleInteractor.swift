//
//  TranslatedListModuleInteractor.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit

final class TranslatedListModuleInteractor {

  // MARK: - Properties

  weak var interactorOutput: TranslatedListModuleInteractorOutputProtocol!
  private let dataBase: DataBaseProtocol

  // MARK: - Initialization

  init( dataBase: DataBaseProtocol) {
    self.dataBase = dataBase
  }

  // MARK: - Private methods

  private func createClearDictionaryAlert() -> UIAlertController {
    let alertController = UIAlertController(title: "Clear Dictionary", message: "Do you want delete all words?", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
      guard let self = self else {return}
      self.clearAllInDictionary()
      }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    return alertController
  }
  private func clearAllInDictionary() {
    self.dataBase.delete(with: .all, inObjects: .dictionaryHistory) { result in
      if let error = result.error {print (error)}
      let translatedWords: [TranslatedObject] = []
      DispatchQueue.main.async {
        self.interactorOutput.prepare(dictionary: translatedWords)
      }
    }
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
        self.interactorOutput.prepare(dictionary: dictionaryHistory)
      }
    }
  }
  func clearDictionary() {
    let alertController = createClearDictionaryAlert()
    output.prepare(alert: alertController)
  }
  func search(text: String) {
    downloadDictionaryHistory(with: .textForTranslate(textForTranslate: text))
  }
}
