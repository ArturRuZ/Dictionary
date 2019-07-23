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
  var testableObject: TranslateInteractorTestableProtocol!

  override func setUp() {
    translateModuleIneractor = TranslateModuleInteractor(translateService: TranslateServiceMock(), dataBase: DataBaseMock())
    let interactorOutput = InteractorOutputMock()
    translateModuleIneractor.output = interactorOutput
    testableObject = interactorOutput as TranslateInteractorTestableProtocol
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
    let translateExpectation = XCTKVOExpectation(keyPath: "isTranslated", object: testableObject ?? InteractorOutputMock())
    dictionaryObjectExpectation.handler = { [weak self] observedObject, _ in
      guard let observedObject = observedObject as? TranslateInteractorTestableProtocol else {
        return false
      }
      guard let self = self else {return false}
      if observedObject.isCreated {
        self.translateModuleIneractor.translate(text: text)
        return true
      }
      return false
    }
    translateExpectation.handler = {observedObject, _ in
      guard let observedObject = observedObject as? TranslateInteractorTestableProtocol else {
        return false
      }
      return observedObject.isTranslated
    }
    // MARK: - When
    self.translateModuleIneractor.createDictionaryObject()
    // MARK: - Then
    let result = XCTWaiter().wait(for: [translateExpectation, dictionaryObjectExpectation], timeout: 15)
    XCTAssertEqual(result, .completed)
  }
  func testChangeLanguageDirection() {
    // MARK: - Given
    let dictionaryObjectExpectation = XCTKVOExpectation(keyPath: "isCreated", object: testableObject ?? InteractorOutputMock())
    let changeLanguageExpectation = XCTKVOExpectation(keyPath: "isLanguageChanged", object: testableObject ?? InteractorOutputMock())
    dictionaryObjectExpectation.handler = { [weak self] observedObject, _ in
      guard let observedObject = observedObject as? TranslateInteractorTestableProtocol else {
        return false
      }
      guard let self = self else {return false}
      if observedObject.isCreated {
        self.translateModuleIneractor.changeLanguageDirection()
        return true
      }
      return false
    }
    changeLanguageExpectation.handler = { observedObject, _ in
      guard let observedObject = observedObject as? TranslateInteractorTestableProtocol else {
        return false
      }
      return observedObject.isLanguageChanged
    }
    // MARK: - When
    self.translateModuleIneractor.createDictionaryObject()
    // MARK: - Then
    let result = XCTWaiter().wait(for: [dictionaryObjectExpectation, changeLanguageExpectation], timeout: 15)
    XCTAssertEqual(result, .completed)
  }
  func testCreateChangeLanguageWindowTag1() {
    // MARK: - Given
    let changeLanguageWindowExpectation = XCTKVOExpectation(keyPath: "isAlertPrepared", object: testableObject ?? InteractorOutputMock())
    // MARK: - When
    self.translateModuleIneractor.createChangeLanguageWindow(forTag: 1)
    // MARK: - Then
    let result = XCTWaiter().wait(for: [changeLanguageWindowExpectation], timeout: 15)
    XCTAssertEqual(result, .completed)
  }
  func testCreateChangeLanguageWindowTag2() {
    // MARK: - Given
    let changeLanguageWindowExpectation = XCTKVOExpectation(keyPath: "isAlertPrepared", object: testableObject ?? InteractorOutputMock())
    // MARK: - When
    self.translateModuleIneractor.createChangeLanguageWindow(forTag: 2)
    // MARK: - Then
    let result = XCTWaiter().wait(for: [changeLanguageWindowExpectation], timeout: 15)
    XCTAssertEqual(result, .completed)
  }
  func testFailedCreateChangeLanguageWindow() {
    // MARK: - Given
    let changeLanguageWindowExpectation = XCTKVOExpectation(keyPath: "isAlertPrepared", object: testableObject ?? InteractorOutputMock())
    // MARK: - When
    self.translateModuleIneractor.createChangeLanguageWindow(forTag: 3)
    // MARK: - Then
    let result = XCTWaiter().wait(for: [changeLanguageWindowExpectation], timeout: 7)
    XCTAssertEqual(result, .timedOut)
  }
}
