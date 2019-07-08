//
//  TranslateModuleAssembly.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit


final class TranslateModuleAssembly {
  func build(translateService: TranslateServiceProtocol, dataBase: DataBaseProtocol) -> (controller: UIViewController, presenter: TranslateModulePresenterInputProtocol)? {
    guard let viewController = TranslateModuleViewController.instantiateFromStoryboard(with: .translateModule) else {return nil}
    let presenter = TranslateModulePresenter()
    let interactor = TranslateModuleInteractor(translateService: translateService, dataBase: dataBase)
    viewController.output = presenter
    presenter.input = interactor
    presenter.output = viewController
    interactor.output = presenter
    return (controller: viewController, presenter: presenter)
  }
}
