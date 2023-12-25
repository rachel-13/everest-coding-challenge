//
//  RouteOptimizer.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 19/12/2023.
//

import Foundation

@main
class RouteOptimizer {
  
  static func main() {
    
    // MARK: Program Setup and Entry Point
    
    let routeOptimizer = RouteOptimizer()
    routeOptimizer.run()
  }
  
  init() {
    
  }
  
  func run() {
    
    
  }
  
  func getOptimalShipment(maxWeight: Double, packageArr:[PackageInfo]) -> Shipment {
    let shipmentLessThanMax = getAllShipmentLessThan(maxWeight: maxWeight, packageArr: packageArr)
    let maxNumberOfPackages = shipmentLessThanMax.max { lhs, rhs in
      return lhs.packages.count <= rhs.packages.count
    }
    
    let filteredShipmentByCount = shipmentLessThanMax.filter { shipment in
      return shipment.packages.count >= maxNumberOfPackages!.packages.count
    }
    
    if filteredShipmentByCount.count == 1 {
      return filteredShipmentByCount[0]
    }
    
    let filteredShipmentByWeight = filteredShipmentByCount.max { lhs, rhs in
      return lhs.totalWeight <= rhs.totalWeight
    }
    
    if let heaviestShipment = filteredShipmentByWeight {
      return heaviestShipment
    }
    
    let filteredShipmentByDeliveryTime = filteredShipmentByCount.sorted { lhs, rhs in
      return lhs.shortestDistancePackage < rhs.shortestDistancePackage
    }
    
    return filteredShipmentByDeliveryTime[0]
  }
  
  func getAllShipmentLessThan(maxWeight: Double, packageArr:[PackageInfo]) -> [Shipment] {
    
    let powerSet = findPowerSet(packageArr: packageArr)
    let filtered = powerSet.filter { subset in
      let sum = subset.reduce(0, { partialResult, packageInfo in
        return partialResult + packageInfo.packageWeightInKg
      })
      
      if sum <= maxWeight {
        return true
      }
          
      return false
    }.map { subset in
      let sum = subset.reduce(0, { partialResult, packageInfo in
        return partialResult + packageInfo.packageWeightInKg
      })
      
      let furthestPackage = subset.max { lhs, rhs in
        return lhs.distanceInKm > rhs.distanceInKm
      }
      
      return Shipment(totalWeight: sum, packages: subset, shortestDistancePackage: 2 * (furthestPackage?.distanceInKm ?? -1))
    }
    
    return filtered
  }
  
  private func findPowerSet(packageArr: [PackageInfo]) -> [[PackageInfo]] {
    var result: [[PackageInfo]] = []
    
    for i in 0..<packageArr.count {
      
      /// Get a copy of all subsets in result, add current element to it and append as result
      for j in 0..<result.count {
        var tempInnerArr =  result[j]
        tempInnerArr.append(packageArr[i])
        result.append(tempInnerArr)
      }
      
      /// Add current element as a subset on its own
      result.append([packageArr[i]])
    }
    
    return result
  }
}
