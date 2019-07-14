//
//  TranslateModulePresenter.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit

final class TranslateModulePresenter {

// MARK: - properties

  private weak var presenterDelegate: TranslateModulePresenterDelegateProtocol!
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
  func show(translatefor: DictionaryObjectProtocol) {
    self.output.show(dictionaryObject: translatefor)
  }
}

// MARK: - TranslateModuleViewOutputProtocol implementation

extension TranslateModulePresenter: TranslateModuleViewOutputProtocol {
  func viewDidLoad() {
    interactor.createDictionaryObject()
  }
  func endEditing(text: String) {
    interactor.translate(text: text)
  }
  func changelanguageButtonPressed(withTag: Int) {
    interactor.createChangeLanguageWindow(forTag: withTag)
  }
  func changelanguageDitrectionButtonPressed() {
    interactor.changeLanguageDirection()
  }
}

// MARK: - TranslateModuleInteractorOutputProtocol implementation

extension TranslateModulePresenter: TranslateModuleInteractorOutputProtocol {
  func prepare(alert: UIAlertController) {
    view.show(alert: alert)
  }
  func prepare(dictionaryObject: DictionaryObjectProtocol) {
    view.show(dictionaryObject: dictionaryObject)
  }
}
