//
//  MockShipmentManager.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 26/12/2023.
//

import Foundation

class MockShipmentManager: ShipmentManagerProtocol {
  
  var stubbedShipmentDeliveryTime = 0.00
  func calculateShipmentDeliveryTime(shipment: Shipment, vehicleSpeedInKmPerHr: Double) -> Double {
    return stubbedShipmentDeliveryTime
  }
  
  var stubbedShipment = Shipment(totalWeight: 0, packages: [], shortestDistancePackageInKm: 0)
  func getOptimalShipment(maxWeight: Double, packageArr: [PackageInfo]) -> Shipment {
    return stubbedShipment
  }
  
  var stubbedShipmentArr: [Shipment] = []
  func getAllShipmentLessThan(maxWeight: Double, packageArr: [PackageInfo]) -> [Shipment] {
    return stubbedShipmentArr
  }
  
  var stubbedPackageDeliveryTime = 0.00
  func calculatePackageDeliveryTime(vehicleSpeedInKmPerHr: Double, vehicleAccumulatedDeliveryTime: Double, package: PackageInfo) -> Double {
    return stubbedPackageDeliveryTime
  }
  
}
