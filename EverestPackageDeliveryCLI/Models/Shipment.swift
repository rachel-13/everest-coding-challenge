//
//  Shipment.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 24/12/2023.
//

import Foundation

struct Shipment {
  let totalWeight: Double
  let packages: [PackageInfo]
  let shortestDistancePackage: Double
}
