//
//  SettingsParams.swift
//  Dictionary
//
//  Created by Артур on 14/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation

final class SettingsParams: SettingsParamsProtocol {
  var languageFrom: String
  var languageTo: String

  init (languageFrom: String, languageTo: String) {
    self.languageFrom = languageFrom
    self.languageTo = languageTo
  }
}
