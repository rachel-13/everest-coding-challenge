//
//  MockCostManager.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 19/12/2023.
//

import Foundation

class MockCostManager: CostManagerProtocol {
  
  var stubbedOriginalCost = 0.00
  func getOriginalDeliveryCost(baseDeliveryCost: Double, packageWeightInKg: Double, destinationDistanceInKm: Double) -> Double {
    return stubbedOriginalCost
  }
  
  var stubbedDiscountAmount = 0.00
  func getDiscountAmount(with offerId: String, originalDeliveryCost: Double, packageWeightInKg: Double, destinationDistanceInKm: Double) -> Double {
    return stubbedDiscountAmount
  }
  
  
}
