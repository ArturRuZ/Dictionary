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
  var testableObject: TestableProtocol!

  override func setUp() {
    translateModuleIneractor = TranslateModuleInteractor(translateService: TranslateServiceMock(), dataBase: DataBase())
    let interactorOutput = InteractorOutputMock()
    translateModuleIneractor.output = interactorOutput
    testableObject = interactorOutput as TestableProtocol
    print ("!!!Setup!!!!")
  }

  override func tearDown() {
    testableObject = nil
    translateModuleIneractor = nil
    print ("!!!TearDown!!!!")
  }

  func testCreateDictionaryObject() {
    // MARK: - Given
    keyValueObservingExpectation(for: testableObject ?? InteractorOutputMock(), keyPath: "isCreated", expectedValue: true)
    // MARK: - When
    translateModuleIneractor.createDictionaryObject()
    // MARK: - Then
    waitForExpectations(timeout: 3)
  }

  func testTranslate() {
    // MARK: - Given
    let text = "Dog"
    let dictionaryObjectExpectation = XCTKVOExpectation(keyPath: "isCreated", object: testableObject ?? InteractorOutputMock())
    let translatExpectation = XCTKVOExpectation(keyPath: "isTranslated", object: testableObject ?? InteractorOutputMock())
    dictionaryObjectExpectation.handler = { [weak self] observedObject, _ in
      guard let observedObject = observedObject as? TestableProtocol else {
        return false
      }
      guard let self = self else {return false}
      if observedObject.isCreated == true {
        self.translateModuleIneractor.translate(text: text)
        return true
      }
      return false
    }
    translatExpectation.handler = {observedObject, _ in
      guard let observedObject = observedObject as? TestableProtocol else {
        return false
      }
      return observedObject.isTranslated == true
    }
    // MARK: - When
    self.translateModuleIneractor.createDictionaryObject()
    // MARK: - Then
    let result = XCTWaiter().wait(for: [translatExpectation, dictionaryObjectExpectation], timeout: 15)
   XCTAssertEqual(result, .completed)
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
