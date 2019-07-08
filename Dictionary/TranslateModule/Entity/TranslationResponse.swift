//
//  TranslationResponse.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


struct TranslationResponse: Codable {
  var result: Results
  var error: String?
  var timestamp: Int
}

struct Results: Codable {
  var translated: String?
}
