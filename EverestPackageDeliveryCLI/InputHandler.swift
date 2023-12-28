//
//  InputHandler.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 28/12/2023.
//

import Foundation

protocol InputHandlerProtocol {
  func handleMetadata(line: String) throws -> (Double, Int)
  func handlePackageInfo(line: String) throws -> PackageInfo
}

class InputHandler: InputHandlerProtocol {
  
  init() {}
  
  func handleMetadata(line: String) throws -> (Double, Int) {
    let userInputArr = line.components(separatedBy: " ")
    
    guard userInputArr.count == 2 else  {
      throw SystemError.incorrectArgumentMetadata
    }
    
    guard let baseDeliveryCost = Double(userInputArr[0]), let numberOfPackages = Int(userInputArr[1]) else {
      throw SystemError.incorrectDataType
    }
    
    guard baseDeliveryCost >= 0, numberOfPackages >= 0 else {
      throw SystemError.negativeNumerics
    }
    
    return (baseDeliveryCost, numberOfPackages)
  }
  
  func handlePackageInfo(line: String) throws -> PackageInfo {
    let userInputArr = line.components(separatedBy: " ")
    
    guard userInputArr.count == 3 || userInputArr.count == 4 else  {
      throw SystemError.incorrectArgumentPackageInfo
    }
    
    guard let packageWeightInKg = Double(userInputArr[1]), let destinationDistanceInKm = Double(userInputArr[2]) else {
      throw SystemError.incorrectDataType
    }
    
    guard packageWeightInKg >= 0, destinationDistanceInKm >= 0 else {
      throw SystemError.negativeNumerics
    }
    
    let packageId = userInputArr[0]
    let offerId: String? = userInputArr.count == 4 ? userInputArr[3] : nil
    
    let packageInfo = PackageInfo(packageID: packageId,
                                  packageWeightInKg: packageWeightInKg,
                                  distanceInKm: destinationDistanceInKm,
                                  offerId: offerId)
    return packageInfo
  }
  
}
