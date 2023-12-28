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
  var mockCostManager: MockCostManager!
  var mockInputHandler: MockInputHandler!
  
  override func setUp() {
    mockErrorHandler = MockErrorHandler()
    mockCostManager = MockCostManager()
    mockInputHandler = MockInputHandler()
    sut = PackageDelivery(errorHandler: mockErrorHandler, costManager: mockCostManager, inputHandler: mockInputHandler)
  }
  
  
  func testCalculatePackageOutput() {
    
    mockCostManager.stubbedOriginalCost = 700
    mockCostManager.stubbedDiscountAmount = 35
    
    let packageInfo = PackageInfo(packageID: "pkg1", packageWeightInKg: 10, distanceInKm: 100, offerId: "testOffer1")
    let packageCost = sut.calculatePackageOutput(packageInfo: packageInfo)
    XCTAssertEqual(packageCost.packageID, packageInfo.packageID)
    XCTAssertEqual(packageCost.discountAmount, 35)
    XCTAssertEqual(packageCost.totalCost, 700)
  }

}
