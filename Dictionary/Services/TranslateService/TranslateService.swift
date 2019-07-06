//
//  TranslateService.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class TranslateService {
  
  private var operationQueue = OperationQueue()
  
  init(){
    operationQueue.name = "Translation queue"
    operationQueue.maxConcurrentOperationCount = 1
  }
  
  private func parse<T>(data: Data,
                        container: T.Type,
                        success: @escaping (T) -> Void,
                        failure: (Error) -> Void) where T : Codable {
    do {
      let response = try JSONDecoder().decode(container, from: data)
      DispatchQueue.main.async {
        success(response)
      }
    } catch {
      failure(error)
    }
  }
  
}

extension TranslateService: TranslateServiceProtocol {
  func loadData<T>(fromURL: URL?,
                   parseInto container: T.Type,
                   success: @escaping (T) -> Void,
                   failure: @escaping (Error) -> Void) where T : Codable {
    guard let url = fromURL else {
      failure(ErrorsList.urlIsIncorrect)
      return
    }
    operationQueue.cancelAllOperations()
    operationQueue.addOperation (
      TranslateOperation(url: url, completion: { [weak self] (data, error) in
        guard let self = self else {return}
        if let error = error { failure(error) } else {
          self.parse(data: data!,
                     container: container,
                     success: success,
                     failure: failure)
        }
      })
    )
  }
}



