//
//  RouterOptimizerTests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 19/12/2023.
//

import XCTest

final class RouterOptimizerTests: XCTestCase {
  
  var sut: RouteOptimizer!

  override func setUp() {
    sut = RouteOptimizer()
  }
  
  func testGetHeaviestBundle() {
    let bundle = sut.getOptimalPackageBundle(maxWeight: 200,
                                             weightArr: [50, 75, 175, 110, 155])
    XCTAssertEqual(bundle, [1, 3])
  }
  
  func testGetNonHeaviestWithMaxPackages() {
    let bundle = sut.getOptimalPackageBundle(maxWeight: 200,
                                             weightArr: [50, 75, 175, 110, 155, 50])
    XCTAssertEqual(bundle, [0, 1, 5])
  }

}
