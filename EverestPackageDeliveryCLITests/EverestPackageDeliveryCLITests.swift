//
//  EverestPackageDeliveryCLITests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 15/12/2023.
//

import XCTest
@testable import EverestPackageDeliveryCLI

final class EverestPackageDeliveryCLITests: XCTestCase {
  
  var sut: PackageDelivery!
  
  override func setUp() {
    sut = PackageDelivery()
  }
  
  func testMetadataIsValid() {
    sut.setupMetadata()
    XCTAssertTrue(sut.isMetadataSet)
  }
  
  override func tearDown() {
   
  }
  
}
