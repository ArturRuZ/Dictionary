//
//  ControllerBuilder.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit

final class ControllerBuilder {
  
  // MARK: - Private properties
  
  private let translateService: TranslateServiceProtocol = TranslateService()
  private let dataBase: DataBaseProtocol = DataBase()
  private weak var modulesCoordinator: ModulesCoordinatorProtocol!
  private var translateModulePresenter: TranslateModulePresenterInputProtocol!
  
  // MARK: - Private methods
  
  private func createTranslateModuleController()->(UIViewController){
    let assembly = TranslateModuleAssembly()
    guard let translateModule = assembly.build(translateService: self.translateService, dataBase: self.dataBase) else {return UIViewController()}
    guard let cordinator = modulesCoordinator as? TranslateModulePresenterDelegateProtocol else {return UIViewController()}
    translateModule.presenter.delegate = cordinator
    self.translateModulePresenter = translateModule.presenter
    let navigationVC = UINavigationController()
    navigationVC.pushViewController(translateModule.controller, animated: true)
    return navigationVC
  }
  private func createTranslatedListModuleController()->(UIViewController){
    let assembly = TranslatedListModuleAssembly()
    guard let translatedListModule = assembly.build(dataBase: self.dataBase) else {return UIViewController()}
    guard let cordinator = modulesCoordinator as? TranslatedListModulePresenterDelegateProtocol else {return UIViewController()}
    let navigationVC = UINavigationController()
    navigationVC.pushViewController(translatedListModule.controller, animated: true)
    translatedListModule.presenter.delegate = cordinator
    return navigationVC
  }
}

  // MARK: - ControllerBuilderProtocol implementation

extension ControllerBuilder: ControllerBuilderProtocol {
  var cordinator: ModulesCoordinatorProtocol {
    get {
      return self.modulesCoordinator
    }
    set {
      self.modulesCoordinator = newValue
    }
  }
  func getTranslateModulePresenter() -> TranslateModulePresenterInputProtocol? {
    return self.translateModulePresenter
  }
  
  
  func buildRootController() -> UIViewController {
    let tabBarController = UITabBarController()
    let translateModuleVC = self.createTranslateModuleController()
    let translateModuleListVC = self.createTranslatedListModuleController()
    translateModuleVC.tabBarItem = UITabBarItem(title: "Translate", image: UIImage(named: "baseline_translate_black_36pt_1x.png"), tag: 0)
    translateModuleListVC.tabBarItem = UITabBarItem(title: "Dictionary", image: UIImage(named: "baseline_library_books_black_36pt_1x.png"), tag: 1)
    tabBarController.setViewControllers([translateModuleVC, translateModuleListVC], animated: false)
    tabBarController.selectedIndex = 0
    return tabBarController
  }
}

