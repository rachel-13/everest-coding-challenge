//
//  CostManager.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 18/12/2023.
//

import Foundation

public protocol CostManagerProtocol {
  func getOriginalDeliveryCost(baseDeliveryCost: Double, packageWeight: Double, destinationDistance: Double) -> Double
  func getDiscountedTotalDeliveryCost(with offerId: String, originalDeliveryCost: Double, packageWeight: Double, destinationDistance: Double) -> Double
}

class CostManager: CostManagerProtocol {
  
  let packageMultiplier: Double = 10
  let distanceMultiplier: Double = 5
  let discountManager: DiscountManagerProtocol
  
  init(discountManager: DiscountManagerProtocol) {
    self.discountManager = discountManager
  }
  
  func getOriginalDeliveryCost(baseDeliveryCost: Double, packageWeight: Double, destinationDistance: Double) -> Double {
    return baseDeliveryCost + (packageWeight * packageMultiplier) + (destinationDistance * distanceMultiplier)
  }
  
  func getDiscountedTotalDeliveryCost(with offerId: String, originalDeliveryCost: Double, packageWeight: Double, destinationDistance: Double) -> Double {
    
    if let validOffer = discountManager.getOffer(withId: offerId),
       discountManager.checkEligibility(for: validOffer.offerID, packageWeight: packageWeight, destinationDistance: destinationDistance) {
      let discountAmount = discountManager.getDiscountAmount(originalDeliveryCost: originalDeliveryCost, offerId: offerId)
      return originalDeliveryCost - discountAmount
    }
    
    return originalDeliveryCost
  }
}
