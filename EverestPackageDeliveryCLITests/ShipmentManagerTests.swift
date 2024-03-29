//
//  RouterOptimizerTests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 19/12/2023.
//

import XCTest

final class RouterOptimizerTests: XCTestCase {
  
  var sut: ShipmentManager!
  
  override func setUp() {
    sut = ShipmentManager()
  }
  
  func testGetSubsetLessThanMaxWeight() {
    let packageInfo1 = PackageInfo(packageID: "testPkg1", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    let packageInfo2 = PackageInfo(packageID: "testPkg2", packageWeightInKg: 75, distanceInKm: 5, offerId: nil)
    let packageInfo3 = PackageInfo(packageID: "testPkg3", packageWeightInKg: 175, distanceInKm: 5, offerId: nil)
    let packageInfo4 = PackageInfo(packageID: "testPkg4", packageWeightInKg: 110, distanceInKm: 5, offerId: nil)
    let packageInfo5 = PackageInfo(packageID: "testPkg5", packageWeightInKg: 155, distanceInKm: 5, offerId: nil)
    
    let result = sut.getAllShipmentLessThan(maxWeight: 200,
                                            packageArr: [packageInfo1, packageInfo2, packageInfo3, packageInfo4, packageInfo5])
    XCTAssertEqual(result.count, 8)
  }
  
  func testGetOptimalShipmentForHeaviestSubset() {
    let packageInfo1 = PackageInfo(packageID: "testPkg1", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    let packageInfo2 = PackageInfo(packageID: "testPkg2", packageWeightInKg: 75, distanceInKm: 5, offerId: nil)
    let packageInfo3 = PackageInfo(packageID: "testPkg3", packageWeightInKg: 175, distanceInKm: 5, offerId: nil)
    let packageInfo4 = PackageInfo(packageID: "testPkg4", packageWeightInKg: 110, distanceInKm: 5, offerId: nil)
    let packageInfo5 = PackageInfo(packageID: "testPkg5", packageWeightInKg: 155, distanceInKm: 5, offerId: nil)
    
    let shipment = sut.getOptimalShipment(maxWeight: 200,
                                          packageArr: [packageInfo1, packageInfo2, packageInfo3, packageInfo4, packageInfo5])
    
    XCTAssertEqual(shipment.packages.count, 2)
    XCTAssertEqual(shipment.totalWeight, 185)
  }
  
  func testGetOptimalShipmentForMaxPackagesSubset() {
    let packageInfo1 = PackageInfo(packageID: "testPkg1", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    let packageInfo2 = PackageInfo(packageID: "testPkg2", packageWeightInKg: 75, distanceInKm: 5, offerId: nil)
    let packageInfo3 = PackageInfo(packageID: "testPkg3", packageWeightInKg: 175, distanceInKm: 5, offerId: nil)
    let packageInfo4 = PackageInfo(packageID: "testPkg4", packageWeightInKg: 110, distanceInKm: 5, offerId: nil)
    let packageInfo5 = PackageInfo(packageID: "testPkg5", packageWeightInKg: 155, distanceInKm: 5, offerId: nil)
    let packageInfo6 = PackageInfo(packageID: "testPkg6", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    
    let shipment = sut.getOptimalShipment(maxWeight: 200,
                                          packageArr: [packageInfo1, packageInfo2, packageInfo3, packageInfo4, packageInfo5, packageInfo6])
    
    XCTAssertEqual(shipment.packages.count, 3)
    XCTAssertEqual(shipment.totalWeight, 175)
  }
  
  func testGetOptimalShipmentForShortestDeliverySubset() {
    let packageInfo1 = PackageInfo(packageID: "testPkg1", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    let packageInfo2 = PackageInfo(packageID: "testPkg2", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    let packageInfo3 = PackageInfo(packageID: "testPkg3", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    let packageInfo4 = PackageInfo(packageID: "testPkg4", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    let packageInfo5 = PackageInfo(packageID: "testPkg5", packageWeightInKg: 50, distanceInKm: 5, offerId: nil)
    let packageInfo6 = PackageInfo(packageID: "testPkg6", packageWeightInKg: 50, distanceInKm: 4, offerId: nil)
    
    let shipment = sut.getOptimalShipment(maxWeight: 200,
                                          packageArr: [packageInfo1, packageInfo2, packageInfo3, packageInfo4, packageInfo5, packageInfo6])
    
    XCTAssertEqual(shipment.packages.count, 4)
    XCTAssertEqual(shipment.totalWeight, 200)
    XCTAssertEqual(shipment.shortestDistancePackageInKm, 4)
  }
  
  func testCalculateShipmentDeliveryTime() {
    let packageInfo1 = PackageInfo(packageID: "testPkg1", packageWeightInKg: 50, distanceInKm: 30, offerId: nil)
    let packageInfo2 = PackageInfo(packageID: "testPkg2", packageWeightInKg: 75, distanceInKm: 125, offerId: nil)
    let packageInfo3 = PackageInfo(packageID: "testPkg3", packageWeightInKg: 175, distanceInKm: 100, offerId: nil)
    let packageInfo4 = PackageInfo(packageID: "testPkg4", packageWeightInKg: 110, distanceInKm: 60, offerId: nil)
    let packageInfo5 = PackageInfo(packageID: "testPkg5", packageWeightInKg: 155, distanceInKm: 95, offerId: nil)
    
    let shipment = Shipment(totalWeight: 185, packages: [packageInfo2, packageInfo4], shortestDistancePackageInKm: 60)
    let shipmentDeliveryTime = sut.calculateShipmentDeliveryTime(shipment: shipment, vehicleSpeedInKmPerHr: 70.0)
    XCTAssertEqual(shipmentDeliveryTime, 3.56)
  }
  
  func testCalculatePackageDeliveryTimeForFirstBatch() {
    let packageInfo1 = PackageInfo(packageID: "testPkg1", packageWeightInKg: 50, distanceInKm: 30, offerId: nil)
    let packageInfo2 = PackageInfo(packageID: "testPkg2", packageWeightInKg: 75, distanceInKm: 125, offerId: nil)
    let packageInfo3 = PackageInfo(packageID: "testPkg3", packageWeightInKg: 175, distanceInKm: 100, offerId: nil)
    let packageInfo4 = PackageInfo(packageID: "testPkg4", packageWeightInKg: 110, distanceInKm: 60, offerId: nil)
    let packageInfo5 = PackageInfo(packageID: "testPkg5", packageWeightInKg: 155, distanceInKm: 95, offerId: nil)
    
    let deliveryTime = sut.calculatePackageDeliveryTime(vehicleSpeedInKmPerHr: 70,
                                                         vehicleAccumulatedDeliveryTime: 0,
                                                         package: packageInfo2)
    XCTAssertEqual(deliveryTime, 1.78)
    
  }
  
  func testCalculatePackageDeliveryTimeForNextBatch() {
    let packageInfo1 = PackageInfo(packageID: "testPkg1", packageWeightInKg: 50, distanceInKm: 30, offerId: nil)
    let packageInfo2 = PackageInfo(packageID: "testPkg2", packageWeightInKg: 75, distanceInKm: 125, offerId: nil)
    let packageInfo3 = PackageInfo(packageID: "testPkg3", packageWeightInKg: 175, distanceInKm: 100, offerId: nil)
    let packageInfo4 = PackageInfo(packageID: "testPkg4", packageWeightInKg: 110, distanceInKm: 60, offerId: nil)
    let packageInfo5 = PackageInfo(packageID: "testPkg5", packageWeightInKg: 155, distanceInKm: 95, offerId: nil)
    
    let deliveryTime = sut.calculatePackageDeliveryTime(vehicleSpeedInKmPerHr: 70,
                                                        vehicleAccumulatedDeliveryTime: 3.56,
                                                        package: packageInfo1)
    XCTAssertEqual(deliveryTime, 3.98)
    
  }
  
}
