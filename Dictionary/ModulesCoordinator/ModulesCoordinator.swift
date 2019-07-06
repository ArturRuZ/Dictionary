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
