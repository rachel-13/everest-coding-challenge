//
//  CostManagerTests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 18/12/2023.
//

import XCTest

final class CostManagerTests: XCTestCase {
  
  var sut: CostManager!
  
  override func setUp() {
    sut = CostManager()
  }
  
  func testGetOriginalTotalDeliveryCost() {
    let totalAmount = sut.getOriginaTotalCost(baseDeliveryCost: 100, packageWeight: 5, destinationDistance: 5)
    XCTAssertEqual(totalAmount, 175)
  }

}
