//
//  TranslateOperation.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation


final class  TranslateOperation: Operation {
  private var task: URLSessionDataTask?
  private var url: URL
  private let completion: (Data?, Error?) -> Void
  
  init(url: URL, completion: @escaping (Data?, Error?) -> Void ) {
    self.url = url
    self.completion = completion
    super.init()
  }
  override func main() {
    let semaphore = DispatchSemaphore(value: 0)
    task = URLSession.shared.dataTask(with: url, completionHandler: { (data,response,error) in
      if !self.isCancelled {
        if let error = error {
          self.completion(nil, error)
          return
        }
        if data != nil {
          self.completion(data!, nil)
        } else {self.completion(nil, ErrorsList.errorData)}
      } else  {self.completion(nil, ErrorsList.translateIsCanceled)}
      semaphore.signal()
    })
    task!.resume()
    semaphore.wait()
  }
  
  override func cancel() {
    super.cancel()
    task?.cancel()
  }
  
}
