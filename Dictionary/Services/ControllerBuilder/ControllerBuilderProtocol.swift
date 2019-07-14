//
//  ControllerBuilderProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit

protocol ControllerBuilderProtocol: class {
  var cordinator: ModulesCoordinatorProtocol {get set}
  func buildRootController() -> UIViewController
  func getTranslateModulePresenter() -> TranslateModulePresenterInputProtocol?
}
