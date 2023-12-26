//
//  RouteOptimizer.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 19/12/2023.
//

import Foundation

@main
class RouteOptimizer {
  
  var isMetadataSet = false
  var numberOfPackages: Int?
  var baseDeliveryCost: Double?
  var packageInfoArray: [PackageInfo] = [PackageInfo]()
  let errorHandler: ErrorHandlerProtocol
  let costManager: CostManagerProtocol
  let shipmentManager: ShipmentManagerProtocol
  
  static func main() {
    
    // MARK: Program Setup and Entry Point
    let errorHandler = ErrorHandler()
    
    let offer1 = Offer(offerID: "OFR001",
                       lowerBoundWeightInKg: 70,
                       upperBoundWeightInKg: 200,
                       lowerBoundDistanceInKm: 0,
                       upperBoundDistanceInKm: 200,
                       discountRateInPercent: 10)
    
    let offer2 = Offer(offerID: "OFR002",
                       lowerBoundWeightInKg: 100,
                       upperBoundWeightInKg: 250,
                       lowerBoundDistanceInKm: 50,
                       upperBoundDistanceInKm: 150,
                       discountRateInPercent: 7)
    
    let offer3 = Offer(offerID: "OFR003",
                       lowerBoundWeightInKg: 10,
                       upperBoundWeightInKg: 150,
                       lowerBoundDistanceInKm: 50,
                       upperBoundDistanceInKm: 250,
                       discountRateInPercent: 5)
    let discountManager = DiscountManager(errorHandler: errorHandler)
    discountManager.insertOffer(offer: offer1)
    discountManager.insertOffer(offer: offer2)
    discountManager.insertOffer(offer: offer3)
    
    let costManager = CostManager(discountManager: discountManager)
    
    let shipmentManager = ShipmentManager()
    
    let routeOptimizer = RouteOptimizer(errorHandler: errorHandler, costManager: costManager, shipmentManager: shipmentManager)
    routeOptimizer.run()
  }
  
  init(errorHandler: ErrorHandlerProtocol, costManager: CostManagerProtocol, shipmentManager: ShipmentManagerProtocol) {
    self.errorHandler = errorHandler
    self.costManager = costManager
    self.shipmentManager = shipmentManager
  }
  
  func run() {
    #if !TEST
      promptForInput()
    #endif
  }
  
  private func promptForInput() {
    print("Type 'quit' to exit.\nPlease enter base weight in KG and number of packages, followed by package information.")
    
    while let line = readLine() {
      if line == "quit" {
        print("Exiting program...")
        break
      }
      
      if !isMetadataSet {
        handleMetadata(line: line)
      } else if let noOfPackages = numberOfPackages, noOfPackages > 0 {
        handlePackageInfo(line: line)
      } else {
        handleVehicleInfo(line: line)
        
      }
    }
  }
  
  func handleMetadata(line: String) {
    do {
      try setupMetadata(line: line)
    } catch (let error) {
      guard let err = error as? SystemError else {
        return
      }
      errorHandler.displayError(error: err)
    }
  }
  
  private func setupMetadata(line: String) throws {
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
    
    self.baseDeliveryCost = baseDeliveryCost
    self.numberOfPackages = numberOfPackages
    
    isMetadataSet = true
  }
  
  func handlePackageInfo(line: String) {
    do {
      try setupPackageInfo(line: line)
    } catch (let error) {
      guard let err = error as? SystemError else {
        return
      }
      errorHandler.displayError(error: err)
    }
  }
  
  private func setupPackageInfo(line: String) throws {
    let userInputArr = line.components(separatedBy: " ")
    
    guard userInputArr.count == 3 || userInputArr.count == 4 else  {
      throw SystemError.incorrectArgumentPackageInfo
    }
    
    guard let packageWeight = Double(userInputArr[1]), let destinationDistance = Double(userInputArr[2]) else {
      throw SystemError.incorrectDataType
    }
    
    guard packageWeight >= 0, destinationDistance >= 0 else {
      throw SystemError.negativeNumerics
    }
    
    let packageId = userInputArr[0]
    let offerId: String? = userInputArr.count == 4 ? userInputArr[3] : nil
    
    let packageInfo = PackageInfo(packageID: packageId,
                                  packageWeightInKg: packageWeight,
                                  distanceInKm: destinationDistance,
                                  offerCode: offerId)
    self.packageInfoArray.append(packageInfo)
    numberOfPackages? -= 1
  }
  
  func handleVehicleInfo(line: String) {
    
  }
  
}
