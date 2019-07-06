//
//  TranslateModuleInteractor.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class TranslateModuleInteractor {
  
    // MARK: - Properties
  
  var interactorOutput: TranslateModuleInteractorOutputProtocol!
  private let translateService: TranslateServiceProtocol
  private let dataBase: DataBaseProtocol
  
  init(translateService: TranslateServiceProtocol, dataBase: DataBaseProtocol) {
    self.translateService = translateService
    self.dataBase = dataBase
  }
  
    // MARK: - Private methods
  
  private func buildUrlToTranslate(from: translationLanguages,to: translationLanguages, text: String) -> String {
    // TO DO %20 when space
    return  "https://api.multillect.com/translate/json/1.0/1165?method=translate/api/translate&from=\(from.rawValue)&to=\(to.rawValue)&text=\(text)&sig=ac0089a730c066aea5a03168bbac6fd7"
  }
}

 // MARK: - TranslateModuleInteractorInputProtocol implementation

extension TranslateModuleInteractor: TranslateModuleInteractorInputProtocol {
  var output: TranslateModuleInteractorOutputProtocol {
    get {
      return interactorOutput
    }
    set {
      interactorOutput = newValue
    }
  }
  // TO DO Result structure
  func translate(text: String) {
    let url = self.buildUrlToTranslate(from: .en, to: .ru, text: text)
    self.translateService.loadData(fromURL: URL(string: url),
                                   parseInto: TranslationResponse.self,
                                   success: {response in print (response)},
                                   failure: {error in print (error)}
  )}
  
}

