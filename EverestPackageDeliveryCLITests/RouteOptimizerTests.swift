//
//  RouteOptimizerTests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 26/12/2023.
//

import XCTest

final class RouteOptimizerTests: XCTestCase {
  
  var sut: RouteOptimizer!
  var mockErrorHandler: MockErrorHandler!
  var mockCostManager: MockCostManager!
  var mockShipmentManager: MockShipmentManager!
  var mockInputHandler: MockInputHandler!
  
  override func setUp() {
    mockErrorHandler = MockErrorHandler()
    mockCostManager = MockCostManager()
    mockShipmentManager = MockShipmentManager()
    mockInputHandler = MockInputHandler()
    sut = RouteOptimizer(errorHandler: mockErrorHandler, costManager: mockCostManager, shipmentManager: mockShipmentManager, inputHandler: mockInputHandler)
  }
  
  
}
