//
//  TranslateService.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class TranslateService {
  
  // MARK: - Properties
  
  private var operationQueue = OperationQueue()
  
  // MARK: - Initialization
  
  init(){
    operationQueue.name = "Translation queue"
    operationQueue.maxConcurrentOperationCount = 1
  }
  
  // MARK: - Private methods
  
  private func parse<T>(data: Data, container: T.Type, completion: @escaping (T?, Error?) -> Void) where T : Codable {
    do {
      let response = try JSONDecoder().decode(container, from: data)
      DispatchQueue.main.async {
        completion (response, nil)
      }
    } catch {
      completion (nil, error)
    }
  }
}

// MARK: - TranslateServiceProtocol implementation

extension TranslateService: TranslateServiceProtocol {
  func translateData<T>(fromURL: URL?, parseInto container: T.Type, completion: @escaping (T?, Error?) -> Void) where T : Codable {
    guard let url = fromURL else {
      completion (nil, ErrorsList.urlIsIncorrect)
      return
    }
    operationQueue.cancelAllOperations()
    operationQueue.addOperation (
      DownloadOperation(url: url, completion: { [weak self] (data, error) in
        guard let self = self else {return}
        if let error = error { completion (nil, error) } else {
          self.parse(data: data!, container: container, completion: completion)
        }
      })
    )
  }
}



