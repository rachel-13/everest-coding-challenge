//
//  DiscountManager.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 18/12/2023.
//

import Foundation

public protocol DiscountManagerProtocol {
  func insertOffer(offer: Offer)
  func getOffer(withId offerId: String) -> Offer?
  func getDiscountAmount(originalDeliveryCost: Double, offerId: String) -> Double
}

class DiscountManager: DiscountManagerProtocol {
  
  private var offerDictionary = [String: Offer]()
  
  func insertOffer(offer: Offer) {
    offerDictionary[offer.offerID.uppercased()] = offer
  }
  
  func getOffer(withId offerId: String) -> Offer? {
    return offerDictionary[offerId.uppercased()]
  }
  
  func getDiscountAmount(originalDeliveryCost: Double, offerId: String) -> Double {
    guard let validOffer = getOffer(withId: offerId) else {
      return 0
    }
    let discountRate = Double(validOffer.discountRateInPercent)/100.0
    return discountRate * originalDeliveryCost
  }
  
  
}
