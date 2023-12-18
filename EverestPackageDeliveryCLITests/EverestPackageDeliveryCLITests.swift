//
//  EverestPackageDeliveryCLITests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 15/12/2023.
//

import XCTest
@testable import EverestPackageDeliveryCLI

final class EverestPackageDeliveryCLITests: XCTestCase {
  
  var sut: PackageDelivery!
  var mockErrorHandler: MockErrorHandler!
  
  override func setUp() {
    mockErrorHandler = MockErrorHandler()
    sut = PackageDelivery(errorHandler: mockErrorHandler)
  }
  
  func testMetadataIsValid() {
    
    sut.handleMetadata(line: "100 3")
    
    XCTAssertFalse(mockErrorHandler.didCallDisplayError)
    XCTAssertTrue(sut.isMetadataSet)
  }
  
  func testMetadataIsInvalid_wrongNumberOfArguments() {
    
    sut.handleMetadata(line: "100 3 4")
    
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.incorrectArgument)
    XCTAssertTrue(mockErrorHandler.didCallDisplayError)
    XCTAssertFalse(sut.isMetadataSet)
  }
  
  func testMetadataIsInvalid_baseweightWrongDataType() {
  
    sut.handleMetadata(line: "abc 3")
  
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.incorrectDataType)
    XCTAssertTrue(mockErrorHandler.didCallDisplayError)
    XCTAssertFalse(sut.isMetadataSet)
  }
  
  func testMetadataIsInvalid_numberOfPackagesWrongDataType() {
   
    sut.handleMetadata(line: "100 a")
   
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.incorrectDataType)
    XCTAssertTrue(mockErrorHandler.didCallDisplayError)
    XCTAssertFalse(sut.isMetadataSet)
  }
  
  override func tearDown() {
   
  }
  
}
