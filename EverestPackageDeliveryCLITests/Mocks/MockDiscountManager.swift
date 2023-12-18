//
//  MockDiscountManager.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 18/12/2023.
//

import Foundation

class MockDiscountManager: DiscountManagerProtocol {
  
  var didCallInsertOffer = false
  var offerCount = 0
  func insertOffer(offer: Offer) {
    didCallInsertOffer = true
    offerCount += 1
  }
  
  func getOffer(withId offerId: String) -> Offer? {
    return nil
  }
  
  var didCallGetDiscountAmount = false
  var stubbedDiscountAmount = 0.00
  func getDiscountAmount(originalDeliveryCost: Double, offerId: String) -> Double {
    didCallGetDiscountAmount = true
    return stubbedDiscountAmount
  }
  
  
}
