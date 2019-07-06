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
  
  // MARK: - Private methods
  
  private func createTranslateModuleController()->(UIViewController){
    let assembly = TranslateModuleAssembly()
    guard let translateModule = assembly.build(translateService: self.translateService, dataBase: self.dataBase) else {return UIViewController()}
    guard let cordinator = modulesCoordinator as? TranslateModulePresenterDelegateProtocol else {return UIViewController()}
    translateModule.presenter.delegate = cordinator
    return translateModule.controller
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
  
  func buildRootController() -> UIViewController {
    let tabBarController = UITabBarController()
    let translateModuleVC = self.createTranslateModuleController()
    translateModuleVC.tabBarItem = UITabBarItem(title: "Dictionary", image: nil, tag: 0)
    let mok1 = UIViewController()
    let mok2 = UIViewController()
    mok1.tabBarItem = UITabBarItem(title: "History", image: nil, tag: 1)
    mok2.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 2)
    tabBarController.setViewControllers([translateModuleVC, mok1, mok2], animated: false)
    tabBarController.selectedIndex = 0
    return tabBarController
  }
}

