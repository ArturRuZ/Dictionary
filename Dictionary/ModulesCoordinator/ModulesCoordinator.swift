//
//  ModulesCoordinator.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit

final class ModulesCoordinator {

  // MARK: - Private properties

  private let controllerBuilder: ControllerBuilderProtocol
  lazy private var rootController: UIViewController = controllerBuilder.buildRootController()

    // MARK: - Initialization

  init(controllerBuilder: ControllerBuilderProtocol) {
    self.controllerBuilder = controllerBuilder
  }

  // MARK: - Private methods

  private func convert(from data: TranslatedListCellModel) -> DictionaryObjectProtocol {
     let convertedData =  DictionaryObject(languageFrom: .en, languageTo: .ru, textForTranslate: data.textForTranslate, translatedText: data.translatedText, time: data.time)
    return convertedData
  }
}

// MARK: - ModulesCoordinatorProtocol implementation

extension ModulesCoordinator: ModulesCoordinatorProtocol {
  func getRootController() -> UIViewController {
    return rootController
  }
}

// MARK: - TranslateModulePresenterDelegateProtocol  implementation

extension ModulesCoordinator: TranslateModulePresenterDelegateProtocol {
}

extension ModulesCoordinator: TranslatedListModulePresenterDelegateProtocol {
  func showTranslateFor(data: TranslatedListCellModel) {
    guard let tabbarController = self.rootController as? UITabBarController else {return}
    guard let presenter = self.controllerBuilder.getTranslateModulePresenter() else {return}
    let dictionaryObject = self.convert(from: data)
    presenter.show(translatefor: dictionaryObject)
    tabbarController.selectedIndex = 0
  }
}
