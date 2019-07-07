//
//  Application.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit
import Foundation


final class Application {
  
  // MARK: - Private properties
  
  private let modulesCoordinator: ModulesCoordinatorProtocol = {
    let controllerBuilder: ControllerBuilderProtocol = ControllerBuilder()
    let modulesCoordinator: ModulesCoordinatorProtocol = ModulesCoordinator(controllerBuilder: controllerBuilder)
    controllerBuilder.cordinator = modulesCoordinator
    return modulesCoordinator
  }()
  
  
  // MARK: - BuildIn Methods
  
  func rootViewController() -> UIViewController {
    return self.modulesCoordinator.getRootController()
  }
}