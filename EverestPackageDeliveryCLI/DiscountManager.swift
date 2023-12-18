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
  let errorHandler: ErrorHandlerProtocol
  
  init(errorHandler: ErrorHandlerProtocol) {
    self.errorHandler = errorHandler
  }
  
  func insertOffer(offer: Offer) {
    
    guard offer.lowerBoundWeightInKg >= 0,
          offer.upperBoundWeightInKg >= 0,
          offer.lowerBoundDistanceInKm >= 0,
          offer.upperBoundDistanceInKm >= 0,
          offer.discountRateInPercent >= 0 else {
      errorHandler.displayError(error: SystemError.negativeNumerics)
      return
    }
    
    offerDictionary[offer.offerID.uppercased()] = offer
  }
  
  func getOffer(withId offerId: String) -> Offer? {
    return offerDictionary[offerId.uppercased()]
  }
  
  func getDiscountAmount(originalDeliveryCost: Double, offerId: String) -> Double {
    guard let validOffer = getOffer(withId: offerId) else {
      return 0
    }
    let discountRate = validOffer.discountRateInPercent/100
    return discountRate * originalDeliveryCost
  }
  
  
}
