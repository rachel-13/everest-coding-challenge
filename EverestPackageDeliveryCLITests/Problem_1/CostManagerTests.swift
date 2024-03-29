//
//  CostManagerTests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 18/12/2023.
//

import XCTest

final class CostManagerTests: XCTestCase {
  
  var sut: CostManager!
  var mockDiscountManager: MockDiscountManager!
  
  override func setUp() {
    mockDiscountManager = MockDiscountManager()
    sut = CostManager(discountManager: mockDiscountManager)
  }
  
  func testGetOriginalTotalDeliveryCost() {
    let totalCost = sut.getOriginalDeliveryCost(baseDeliveryCost: 100, packageWeightInKg: 5, destinationDistanceInKm: 5)
    XCTAssertEqual(totalCost, 175)
  }
  
  func testGetDiscountAmount_validAndEligibleOffer() {
    
    mockDiscountManager.stubbedDiscountAmount = 35
    mockDiscountManager.stubbedEligibility = true
    mockDiscountManager.stubbedOffer = Offer(offerID: "testOffer1",
                                             lowerBoundWeightInKg: 0,
                                             upperBoundWeightInKg: 5,
                                             lowerBoundDistanceInKm: 0,
                                             upperBoundDistanceInKm: 20,
                                             discountRateInPercent: 5)
    
    let originalDeliveryCost = sut.getOriginalDeliveryCost(baseDeliveryCost: 100, packageWeightInKg: 10, destinationDistanceInKm: 100)
    let discountAmount = sut.getDiscountAmount(with: "testOffer1", originalDeliveryCost: originalDeliveryCost, packageWeightInKg: 5, destinationDistanceInKm: 5)
    let discountedCost = originalDeliveryCost - discountAmount
    XCTAssertEqual(discountedCost, 665)
  }
  
}
