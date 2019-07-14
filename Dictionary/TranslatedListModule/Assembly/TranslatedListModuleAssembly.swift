//
//  TranslatedListModuleAssembly.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit

final class TranslatedListModuleAssembly {
    func build(dataBase: DataBaseProtocol) -> (controller: UIViewController, presenter: TranslatedListModulePresenterInputProtocol)? {
      guard let viewController = TranslatedListModuleViewController.instantiateFromStoryboard(with: .translatedListModule) else {return nil}
      let presenter = TranslatedListModulePresenter()
     let interactor = TranslatedListModuleInteractor(dataBase: dataBase)
     viewController.output = presenter
     presenter.input = interactor
     presenter.output = viewController
     interactor.output = presenter
      return (controller: viewController, presenter: presenter)
    }
}
