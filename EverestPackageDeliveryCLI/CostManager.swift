//
//  CostManager.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 18/12/2023.
//

import Foundation

public protocol CostManagerProtocol {
  func getOriginaTotalCost(baseDeliveryCost: Double, packageWeight: Double, destinationDistance: Double) -> Double
}

class CostManager: CostManagerProtocol {
  
  let packageMultiplier: Double = 10
  let distanceMultiplier: Double = 5
  
  func getOriginaTotalCost(baseDeliveryCost: Double, packageWeight: Double, destinationDistance: Double) -> Double {
    return baseDeliveryCost + (packageWeight * packageMultiplier) + (destinationDistance * distanceMultiplier)
  }
}
