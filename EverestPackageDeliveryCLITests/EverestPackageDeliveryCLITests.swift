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
    sut.setupMetadata(line: "100 3")
    XCTAssertTrue(sut.isMetadataSet)
  }
  
  func testMetadataIsInvalid_wrongNumberOfArguments() {
    sut.setupMetadata(line: "100 3 4")
    XCTAssertFalse(sut.isMetadataSet)
  }
  
  func testMetadataIsInvalid_baseweightWrongDataType() {
    sut.setupMetadata(line: "abc 3")
    XCTAssertFalse(sut.isMetadataSet)
  }
  
  func testMetadataIsInvalid_numberOfPackagesWrongDataType() {
    sut.setupMetadata(line: "100 a")
    XCTAssertFalse(sut.isMetadataSet)
  }
  
  override func tearDown() {
   
  }
  
}
