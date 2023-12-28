//
//  MockInputHandler.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 28/12/2023.
//

import Foundation

class MockInputHandler: InputHandlerProtocol {
  
  var stubbedMetadata = (0.0, 0)
  func handleMetadata(line: String) throws -> (Double, Int) {
    return stubbedMetadata
  }
  
  var stubbedPackageInfo = PackageInfo(packageID: "", packageWeightInKg: 0, distanceInKm: 0, offerId: nil)
  func handlePackageInfo(line: String) throws -> PackageInfo {
    return stubbedPackageInfo
  }
  
  
}
