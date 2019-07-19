//
//  InteractorOutputMock.swift
//  DictionaryTests
//
//  Created by Артур on 16/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit
@testable import Dictionary

class InteractorOutputMock: NSObject, TranslateModuleInteractorOutputProtocol, TestableProtocol {

  @objc dynamic var isCreated = false
  @objc dynamic var isTranslated = false

  func prepare(dictionaryObject: DictionaryObjectProtocol) {
    if dictionaryObject.isDefault() {isCreated = true} else {
      isTranslated = true
    }
  }
  func prepare(alert: UIAlertController) {
  }
}
