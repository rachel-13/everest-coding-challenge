//
//  CostManager.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 18/12/2023.
//

import Foundation

public protocol CostManagerProtocol {
  func getOriginalDeliveryCost(baseDeliveryCost: Double, packageWeightInKg: Double, destinationDistanceInKm: Double) -> Double
  func getDiscountAmount(with offerId: String, originalDeliveryCost: Double, packageWeightInKg: Double, destinationDistanceInKm: Double) -> Double
}

class CostManager: CostManagerProtocol {
  
  let packageMultiplier: Double = 10
  let distanceMultiplier: Double = 5
  let discountManager: DiscountManagerProtocol
  
  init(discountManager: DiscountManagerProtocol) {
    self.discountManager = discountManager
  }
  
  func getOriginalDeliveryCost(baseDeliveryCost: Double, packageWeightInKg: Double, destinationDistanceInKm: Double) -> Double {
    return baseDeliveryCost + (packageWeightInKg * packageMultiplier) + (destinationDistanceInKm * distanceMultiplier)
  }
  
  func getDiscountAmount(with offerId: String, originalDeliveryCost: Double, packageWeightInKg: Double, destinationDistanceInKm: Double) -> Double {
    if let validOffer = discountManager.getOffer(withId: offerId),
       discountManager.checkEligibility(for: validOffer.offerID, packageWeightInKg: packageWeightInKg, destinationDistanceInKm: destinationDistanceInKm) {
      let discountAmount = discountManager.getDiscountAmount(originalDeliveryCost: originalDeliveryCost, offerId: offerId)
      return discountAmount
    }
    
    return 0
  }
}
