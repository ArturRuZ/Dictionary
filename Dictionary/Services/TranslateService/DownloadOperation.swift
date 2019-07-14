//
//  DownloadOperation.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation

final class  DownloadOperation: Operation {

  // MARK: - Properties

  private var task: URLSessionDataTask?
  private var url: URL
  private let completion: (Result<Data>) -> Void

  // MARK: - Initialization

  init(url: URL, completion: @escaping (Result<Data>) -> Void ) {
    self.url = url
    self.completion = completion
    super.init()
  }

  // MARK: - BuildIn Methods

  override func main() {
    let semaphore = DispatchSemaphore(value: 0)
    self.task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
      if self.isCancelled {
        self.completion(Result(error: ErrorsList.translateIsCanceled))
      }
      if let error = error {
        self.completion(Result(error: error))
      }
      guard let data = data else {
        self.completion(Result(error: ErrorsList.errorData))
        return
      }
      self.completion(Result(value: data))
      semaphore.signal()
    })
    self.task?.resume()
    semaphore.wait()
  }

  override func cancel() {
    super.cancel()
    self.task?.cancel()
  }
}
