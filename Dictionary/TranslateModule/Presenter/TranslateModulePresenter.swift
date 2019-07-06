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
}

// MARK: - TranslateModuleViewOutputProtocol implementation

extension TranslateModulePresenter: TranslateModuleViewOutputProtocol {
  func textDidChangeTo(text: String) {
    interactor.translate(text: text)
  }
}

// MARK: - TranslateModuleInteractorOutputProtocol implementation

extension TranslateModulePresenter: TranslateModuleInteractorOutputProtocol {
  
}
