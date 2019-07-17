//
//  TranslateModuleInteractorTest.swift
//  DictionaryTests
//
//  Created by Артур on 16/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import XCTest
@testable import Dictionary

class TranslateModuleInteractorTest: XCTestCase {
  var translateModuleIneractor: TranslateModuleInteractorInputProtocol!
  var interactorOutput: TranslateModuleInteractorOutputProtocol!
  var testableObject: Testable!

  override func setUp() {
    translateModuleIneractor = TranslateModuleInteractor(translateService: TranslateServiceMock(), dataBase: DataBase())
    interactorOutput = InteractorOutputMock()
    translateModuleIneractor.output = interactorOutput
    testableObject = interactorOutput as? Testable
  }

  override func tearDown() {
    translateModuleIneractor = nil
    interactorOutput = nil
    testableObject = nil
  }
  func testCreateDictionaryObject() {
    // MARK: - Given
    guard let object = testableObject else {
      XCTFail("no testableObject")
      return
    }
    keyValueObservingExpectation(for: object, keyPath: "isCreated", expectedValue: "true")
    // MARK: - When
    translateModuleIneractor.createDictionaryObject()
    // MARK: - Then
    waitForExpectations(timeout: 7)
  }

  func testTranslate() {
   let tes
  }
//  func changeLanguageDirection()
//  func createChangeLanguageWindow(forTag: Int)

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
