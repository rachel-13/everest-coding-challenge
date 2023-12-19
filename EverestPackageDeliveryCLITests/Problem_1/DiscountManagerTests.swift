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
  var mockErrorHandler: MockErrorHandler!
  
  override func setUp() {
    mockErrorHandler = MockErrorHandler()
    sut = DiscountManager(errorHandler: mockErrorHandler)
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
  
  func testInsertOffer_negativeWeight() {
    
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 0,
                       upperBoundWeightInKg: -10,
                       lowerBoundDistanceInKm: 10,
                       upperBoundDistanceInKm: 30,
                       discountRateInPercent: 10)
    sut.insertOffer(offer: offer1)
    
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.negativeNumerics)
  }
  
  func testInsertOffer_negativeDistance() {
    
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 0,
                       upperBoundWeightInKg: 10,
                       lowerBoundDistanceInKm: 10,
                       upperBoundDistanceInKm: -30,
                       discountRateInPercent: 10)
    sut.insertOffer(offer: offer1)
    
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.negativeNumerics)
  }
  
  func testInsertOffer_negativeDiscountRate() {
    
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 0,
                       upperBoundWeightInKg: 10,
                       lowerBoundDistanceInKm: 10,
                       upperBoundDistanceInKm: 30,
                       discountRateInPercent: -10)
    sut.insertOffer(offer: offer1)
    
    XCTAssertEqual(mockErrorHandler.stubbedError, SystemError.negativeNumerics)
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
    
    let discountAmount = sut.getDiscountAmount(originalDeliveryCost: 125, offerId: "testOffer2")
    XCTAssertEqual(discountAmount, 12.5)
  }
  
  func testGetDiscountAmount_withInvalidOffer() {
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
    
    let discountAmount = sut.getDiscountAmount(originalDeliveryCost: 125, offerId: "testOffer3")
    XCTAssertEqual(discountAmount, 0)
  }
  
  func testElilibility_eligible() {
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 10,
                       upperBoundWeightInKg: 150,
                       lowerBoundDistanceInKm: 50,
                       upperBoundDistanceInKm: 250,
                       discountRateInPercent: 7)
    sut.insertOffer(offer: offer1)
    
    let eligible = sut.checkEligibility(for: "testOffer1", packageWeight: 10, destinationDistance: 100)
    XCTAssertTrue(eligible)
  }
  
  func testElilibility_ineligibleWeight() {
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 10,
                       upperBoundWeightInKg: 150,
                       lowerBoundDistanceInKm: 50,
                       upperBoundDistanceInKm: 250,
                       discountRateInPercent: 7)
    sut.insertOffer(offer: offer1)
    
    let eligible = sut.checkEligibility(for: "testOffer1", packageWeight: 9, destinationDistance: 100)
    XCTAssertFalse(eligible)
  }
  
  func testElilibility_ineligibleDistance() {
    let offer1 = Offer(offerID: "testOffer1",
                       lowerBoundWeightInKg: 10,
                       upperBoundWeightInKg: 150,
                       lowerBoundDistanceInKm: 50,
                       upperBoundDistanceInKm: 250,
                       discountRateInPercent: 7)
    sut.insertOffer(offer: offer1)
    
    let eligible = sut.checkEligibility(for: "testOffer1", packageWeight: 10, destinationDistance: 45)
    XCTAssertFalse(eligible)
  }
  
}
