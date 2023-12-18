//
//  DiscountManagerTests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 18/12/2023.
//

import XCTest
@testable import EverestPackageDeliveryCLI

final class DiscountManagerTests: XCTestCase {
  
  var sut: DiscountManager!
  
  override func setUp() {
    sut = DiscountManager()
  }
  
  func testInsertOffer_validInsertion() {
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 0,
                       upperBoundWeightInKg: 5,
                       lowerBoundDistanceInKm: 0,
                       upperBoundDistanceInKm: 20,
                       discountRateInPercent: 5)
    sut.insertOffer(offer: offer1)
    XCTAssertEqual(sut.getOffer(withId: offer1.offerID)?.discountRateInPercent, 5)
  }
  
  func testInsertOffer_overrideExistingOfferId() {
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 0,
                       upperBoundWeightInKg: 5,
                       lowerBoundDistanceInKm: 0,
                       upperBoundDistanceInKm: 20,
                       discountRateInPercent: 5)
    sut.insertOffer(offer: offer1)
    
    let offer2 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 0,
                       upperBoundWeightInKg: 10,
                       lowerBoundDistanceInKm: 10,
                       upperBoundDistanceInKm: 30,
                       discountRateInPercent: 10)
    sut.insertOffer(offer: offer2)
    
    XCTAssertEqual(sut.getOffer(withId: "testOffer1")?.discountRateInPercent, 10)
  }
  
  func testGetDiscountAmount_withValidOffer() {
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 0,
                       upperBoundWeightInKg: 5,
                       lowerBoundDistanceInKm: 0,
                       upperBoundDistanceInKm: 20,
                       discountRateInPercent: 5)
    sut.insertOffer(offer: offer1)
    
    let offer2 = Offer(offerID: "testOffer2",
                       lowerBoundWeightInKg: 0,
                       upperBoundWeightInKg: 10,
                       lowerBoundDistanceInKm: 10,
                       upperBoundDistanceInKm: 30,
                       discountRateInPercent: 10)
    sut.insertOffer(offer: offer2)
    
    let discountAmount = sut.getDiscountAmount(originalDeliveryCost: 100, offerId: "testOffer2")
    XCTAssertEqual(discountAmount, 10)
  }

}
