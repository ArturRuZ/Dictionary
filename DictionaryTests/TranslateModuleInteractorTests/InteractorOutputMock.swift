//
//  InteractorOutputMock.swift
//  DictionaryTests
//
//  Created by Артур on 16/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit
@testable import Dictionary

class InteractorOutputMock: NSObject, TranslateModuleInteractorOutputProtocol, Testable {

  @objc dynamic var isCreated: NSString = "false"

  func prepare(dictionaryObject: DictionaryObjectProtocol) {
    if dictionaryObject.isDefault() {isCreated = "true"}
  }
  func prepare(alert: UIAlertController) {
  }
}

@objc protocol Testable: class {
 @objc dynamic var isCreated: NSString {get}
}
