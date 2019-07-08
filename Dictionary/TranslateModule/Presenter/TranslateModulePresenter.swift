//
//  TranslateModulePresenter.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class TranslateModulePresenter {
  
    // MARK: - properties
  
  private weak var presenterDelegate : TranslateModulePresenterDelegateProtocol!
  private weak var view: TranslateModuleViewInputProtocol!
  private var interactor: TranslateModuleInteractorInputProtocol!
  
}

// MARK: - TranslateModulePresenterInputProtocol implementation

extension TranslateModulePresenter: TranslateModulePresenterInputProtocol {
  var delegate: TranslateModulePresenterDelegateProtocol {
    get {
      return presenterDelegate
    }
    set {
      presenterDelegate = newValue
    }
  }
  
  var input: TranslateModuleInteractorInputProtocol {
    get {
      return interactor
    }
    set {
      interactor = newValue
    }
  }
  
  var output: TranslateModuleViewInputProtocol {
    get {
      return view
    }
    set {
      view = newValue
    }
  }
  func show(Translatefor: DictionaryObjectProtocol) {
    self.output.show(dictionaryObject: Translatefor)
  }
}

// MARK: - TranslateModuleViewOutputProtocol implementation

extension TranslateModulePresenter: TranslateModuleViewOutputProtocol {
  func viewDidLoad() {
   interactor.prepareDictionaryObject()
  }
  
  func endEditing(dictionaryObject: DictionaryObjectProtocol) {
    interactor.translate(data: dictionaryObject)
  }
}

// MARK: - TranslateModuleInteractorOutputProtocol implementation

extension TranslateModulePresenter: TranslateModuleInteractorOutputProtocol {
  func prepared(dictionaryObject: DictionaryObjectProtocol) {
    view.show(dictionaryObject: dictionaryObject)
  }
}
