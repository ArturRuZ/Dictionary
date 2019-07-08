//
//  TranslatedListModulePresenter.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class TranslatedListModulePresenter {
  
  //MARK: - Properties
  
  private weak var presenterDelegate :TranslatedListModulePresenterDelegateProtocol!
  private weak var view: TranslatedListModuleViewInputProtocol!
  private var interactor: TranslatedListModuleInteractorInputProtocol!
  
  
}

 //MARK: - TranslatedListModulePresenterInputProtocol implementation

extension TranslatedListModulePresenter: TranslatedListModulePresenterInputProtocol {
  var delegate: TranslatedListModulePresenterDelegateProtocol {
    get {
      return presenterDelegate
    }
    set {
      presenterDelegate = newValue
    }
  }
  
  var input: TranslatedListModuleInteractorInputProtocol {
    get {
      return interactor
    }
    set {
      interactor = newValue
    }
  }
  
  var output: TranslatedListModuleViewInputProtocol {
    get {
      return view
    }
    set {
      view = newValue
    }
  }
}

//MARK: - TranslatedListModuleViewOutputProtocol  implementation

extension TranslatedListModulePresenter: TranslatedListModuleViewOutputProtocol {
  func viewWillAppear() {
    interactor.downloadDictionaryHistory(with: .all)
  }
  func deleteButtonPressed() {
    interactor.clearDictionary()
  }
  func textInputInSearchBar(text: String) {
    interactor.search(text: text)
  }
  func searchingEnding() {
    interactor.downloadDictionaryHistory(with: .all)
  }
  func rowSelected(with: TranslatedListCellModel) {
    delegate.show(translateFor: with)
  }
}

// MARK: - TranslatedListModuleInteractorOutputProtocol implementation

extension TranslatedListModulePresenter: TranslatedListModuleInteractorOutputProtocol {
  func prepared(dictionary: [TranslatedListCellModel]) {
    self.view.show(dictionary: dictionary)
  }
}
