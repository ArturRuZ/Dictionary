//
//  TestableProtocol.swift
//  DictionaryTests
//
//  Created by Артур on 19/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation

@objc protocol TestableProtocol: class {
  @objc dynamic var isCreated: Bool {get set}
  @objc dynamic var isTranslated: Bool {get set}
}
