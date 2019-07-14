//
//  TranslateServiceProtocol.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation

protocol TranslateServiceProtocol: class {
  func translateData<T>(fromURL: URL?, parseInto container: T.Type, completion: @escaping (Result<T>) -> Void) where T: Codable
}
