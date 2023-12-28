//
//  PackageDelivery.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 15/12/2023.
//

import Foundation

@main
class PackageDelivery {
  
  var isMetadataSet = false
  var numberOfPackages: Int?
  var baseDeliveryCost: Double?
  var packageInfoArray: [PackageInfo] = [PackageInfo]()
  let errorHandler: ErrorHandlerProtocol
  let costManager: CostManagerProtocol
  let inputHandler: InputHandlerProtocol
  
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
    
    let inputHandler = InputHandler()
    
    let packageDelivery = PackageDelivery(errorHandler: errorHandler, costManager: costManager, inputHandler: inputHandler)
    packageDelivery.run()
  }
  
  init(errorHandler: ErrorHandlerProtocol, costManager: CostManagerProtocol, inputHandler: InputHandlerProtocol) {
    self.errorHandler = errorHandler
    self.costManager = costManager
    self.inputHandler = inputHandler
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
      
      do {
        if !isMetadataSet {
          let tuple = try inputHandler.handleMetadata(line: line)
          self.baseDeliveryCost = tuple.0
          self.numberOfPackages = tuple.1
          isMetadataSet = true
        } else if let noOfPackages = numberOfPackages, noOfPackages > 0 {
          let packageInfo = try inputHandler.handlePackageInfo(line: line)
          self.packageInfoArray.append(packageInfo)
          numberOfPackages? -= 1
          
          if numberOfPackages == 0 {
            print("Your package discount and costs are:")
            printOutput()
            break
          }
        }
      } catch (let error) {
        guard let err = error as? SystemError else {
          errorHandler.displayError(error: SystemError.unknown)
          return
        }
        errorHandler.displayError(error: err)
      }
    }
  }
  
  private func printOutput() {
    for packageInfo in self.packageInfoArray {
      let packageCost = calculatePackageOutput(packageInfo: packageInfo)
      print(String(format: "%@ %.2f %.2f", packageCost.packageID, packageCost.discountAmount, packageCost.totalCost - packageCost.discountAmount))
    }
  }
  
  func calculatePackageOutput(packageInfo: PackageInfo) -> PackageCost {
    
    let originalDeliveryCost = costManager.getOriginalDeliveryCost(baseDeliveryCost: self.baseDeliveryCost ?? 0,
                                                                   packageWeightInKg: packageInfo.packageWeightInKg,
                                                                   destinationDistanceInKm: packageInfo.distanceInKm)
    
    var discountAmount = 0.00
    if let offerId = packageInfo.offerId {
      discountAmount = costManager.getDiscountAmount(with: offerId,
                                                         originalDeliveryCost: originalDeliveryCost,
                                                         packageWeightInKg: packageInfo.packageWeightInKg,
                                                         destinationDistanceInKm: packageInfo.distanceInKm)
    }
    
    return PackageCost(packageID: packageInfo.packageID, discountAmount: discountAmount, totalCost: originalDeliveryCost)
  }
}

