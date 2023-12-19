//
//  PackageDeliveryTests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 15/12/2023.
//

import XCTest
@testable import EverestPackageDeliveryCLI

final class PackageDeliveryTests: XCTestCase {
  
  var sut: PackageDelivery!
  var mockErrorHandler: MockErrorHandler!
  var mockDiscountManager: MockDiscountManager!
  
  override func setUp() {
    mockErrorHandler = MockErrorHandler()
    mockDiscountManager = MockDiscountManager()
    sut = PackageDelivery(errorHandler: mockErrorHandler, discountManager: mockDiscountManager)
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
  
  func testMetadataIsInvalid_baseDeliveryCostWrongDataType() {
  
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
  
  func testMetadataIsInvalid_negativeBaseDeliveryCost() {
    
    sut.handleMetadata(line: "-100 3")
    
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.negativeNumerics)
    XCTAssertTrue(mockErrorHandler.didCallDisplayError)
    XCTAssertFalse(sut.isMetadataSet)
  }
  
  func testMetadataIsInvalid_negativeNumberOfPackages() {
    
    sut.handleMetadata(line: "100 -3")
    
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.negativeNumerics)
    XCTAssertTrue(mockErrorHandler.didCallDisplayError)
    XCTAssertFalse(sut.isMetadataSet)
  }
  
  func testSetupPackageInfo_succeed() {
    
    sut.handlePackageInfo(line: "PKG1 5 5 testOffer1")
    sut.handlePackageInfo(line: "PKG2 15 5 testOffer2")
    sut.handlePackageInfo(line: "PKG3 10 100 testOffer3")
    XCTAssertEqual(sut.packageInfoArray.count, 3)
  }
  
  func testSetupPackageInfo_withNoOffers_succeeds() {
    sut.handlePackageInfo(line: "PKG1 5 5")
    sut.handlePackageInfo(line: "PKG2 15 5")
    XCTAssertEqual(sut.packageInfoArray.count, 2)
  }
  
  func testSetupPackageInfo_negativePackageWeightInKg_fails() {
    
    sut.handlePackageInfo(line: "PKG1 -5 5")
    
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.negativeNumerics)
    XCTAssertTrue(mockErrorHandler.didCallDisplayError)
    XCTAssertEqual(sut.packageInfoArray.count, 0)
  }
  
  func testSetupPackageInfo_negativeDestinationDistancetInKm_fails() {
    
    sut.handlePackageInfo(line: "PKG1 5 -5")
    
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.negativeNumerics)
    XCTAssertTrue(mockErrorHandler.didCallDisplayError)
    XCTAssertEqual(sut.packageInfoArray.count, 0)
  }
  
}
