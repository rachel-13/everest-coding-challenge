//
//  InputHandlerTests.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 28/12/2023.
//

import XCTest

final class InputHandlerTests: XCTestCase {
  
  var sut: InputHandler!
  
  override func setUp() {
    sut = InputHandler()
  }
  
  func testMetadataIsValid() {
    
    let result = try? sut.handleMetadata(line: "100 3")
    
    XCTAssertEqual(result?.0, 100.0)
    XCTAssertEqual(result?.1, 3)
  }
  
  func testMetadataIsInvalid_wrongNumberOfArguments() {
    
    do {
      _ = try sut.handleMetadata(line: "100 3 4")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.incorrectArgumentMetadata)
    }
  }
  
  func testMetadataIsInvalid_baseDeliveryCostWrongDataType() {
    
    do {
      _ = try sut.handleMetadata(line: "abc 3")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.incorrectDataType)
    }
  }

  func testMetadataIsInvalid_numberOfPackagesWrongDataType() {
    
    do {
      _ = try sut.handleMetadata(line: "100 a")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.incorrectDataType)
    }
  }
  
  func testMetadataIsInvalid_negativeBaseDeliveryCost() {
    
    do {
      _ = try sut.handleMetadata(line: "-100 3")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.negativeNumerics)
    }
  }
  
  func testMetadataIsInvalid_negativeNumberOfPackages() {
    
    do {
      _ = try sut.handleMetadata(line: "100 -3")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.negativeNumerics)
    }
  }
  
  func testSetupPackageInfo_succeed() {
    do {
      let packageInfo = try sut.handlePackageInfo(line: "PKG1 5 5 testOffer1")
      XCTAssertEqual(packageInfo.packageID, "PKG1")
      XCTAssertEqual(packageInfo.distanceInKm, 5)
      XCTAssertEqual(packageInfo.packageWeightInKg, 5)
      XCTAssertEqual(packageInfo.offerId, "testOffer1")
    } catch {
      
    }
  }

  func testSetupPackageInfo_withNoOffers_succeeds() {
    
    do {
      let packageInfo = try sut.handlePackageInfo(line: "PKG1 5 5")
      XCTAssertEqual(packageInfo.packageID, "PKG1")
      XCTAssertEqual(packageInfo.distanceInKm, 5)
      XCTAssertEqual(packageInfo.packageWeightInKg, 5)
      XCTAssertNil(packageInfo.offerId)
    } catch {
      
    }
  }
  
  func testSetupPackageInfo_negativePackageWeightInKg_fails() {
    
    do {
      _ = try sut.handlePackageInfo(line: "PKG1 -5 5")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.negativeNumerics)
    }
  
  }
  
  func testSetupPackageInfo_negativeDestinationDistancetInKm_fails() {
    
    do {
      _ = try sut.handlePackageInfo(line: "PKG1 5 -5")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.negativeNumerics)
    }
  }
  
  func testSetupVehicleInfo() {
    let result = try? sut.handleVehicleInfo(line: "2 70 200")
    
    XCTAssertEqual(result?.count, 2)
  }
  
  func testSetupVehicleInfo_negativeNumberOfVehicles() {
    
    do {
      _ = try sut.handleVehicleInfo(line: "-2 70 200")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.negativeNumerics)
    }
  }

  func testSetupVehicleInfo_negativeMaxSpeed() {
    
    do {
      _ = try sut.handleVehicleInfo(line: "2 -70 200")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.negativeNumerics)
    }
  }
  
  func testSetupVehicleInfo_negativeMaxWeight() {
    
    do {
      _ = try sut.handleVehicleInfo(line: "2 70 -200")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.negativeNumerics)
    }
  }
  
  func testSetupVehicleInfo_incorrectNumberOfArguments() {
    
    do {
      _ = try sut.handleVehicleInfo(line: "2 70")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.incorrectArgumentVehicleInfo)
    }
  }
  
  func testSetupVehicleInfo_incorrectDataType() {
    
    do {
      _ = try sut.handleVehicleInfo(line: "2 70 abc")
    } catch (let error) {
      XCTAssertEqual(error as? SystemError, SystemError.incorrectDataType)
    }
  }
}
