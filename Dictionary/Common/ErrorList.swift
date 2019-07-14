//
//  ErrorList.swift
//  Dictionary
//
//  Created by Артур on 13/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation

enum ErrorsList: Error {
  case urlIsIncorrect
  case errorData
  case translateIsCanceled
  case fetchRequestBuildFailed(_ :String)
  case couldntCastObjectToNecessaryType(_ :String)
  case couldntInitEntity(_ :String)
  case coudntConvertObject
  case noSuchTypeForDownload
  case obgectsNoFound
  case saveFaild
}
