//
//  RouteOptimizer.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 19/12/2023.
//

import Foundation

//@main
class RouteOptimizer {
  
  var isMetadataSet = false
  var numberOfPackages: Int?
  var baseDeliveryCost: Double?
  var packageInfoArray: [PackageInfo] = [PackageInfo]()
  var vehicleInfoArray: [VehicleInfo] = [VehicleInfo]()
  let errorHandler: ErrorHandlerProtocol
  let costManager: CostManagerProtocol
  let shipmentManager: ShipmentManagerProtocol
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
    
    let shipmentManager = ShipmentManager()
    
    let inputHandler = InputHandler()
    
    let routeOptimizer = RouteOptimizer(errorHandler: errorHandler, costManager: costManager, shipmentManager: shipmentManager, inputHandler: inputHandler)
    routeOptimizer.run()
  }
  
  init(errorHandler: ErrorHandlerProtocol, costManager: CostManagerProtocol, shipmentManager: ShipmentManagerProtocol, inputHandler: InputHandlerProtocol) {
    self.errorHandler = errorHandler
    self.costManager = costManager
    self.shipmentManager = shipmentManager
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
        } else {
          vehicleInfoArray = try inputHandler.handleVehicleInfo(line: line)
          printOutput()
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
    for package in calculatePackageOutput() {
      print(String(format: "%@ %.2f %.2f %.2f", 
                   package.packageID,
                   package.discountAmount,
                   package.totalCost - package.discountAmount,
                   package.deliveryTime))
    }
  }
  
  private func calculatePackageOutput() -> [PackageCostWithTime] {
    
    var outputDictionary = [String: PackageCostWithTime]()
    var tempPackageInfoArray: [PackageInfo] = Array(packageInfoArray)
    
    while(tempPackageInfoArray.count > 0) {
      
      /// Get a vehicle first
      let optimalShipment = shipmentManager.getOptimalShipment(maxWeight: vehicleInfoArray[0].maxWeight, packageArr: tempPackageInfoArray)
      let allotedVehicle = vehicleInfoArray.min { lhs, rhs in
        return lhs.accumulatedDeliveryTime <= rhs.accumulatedDeliveryTime
      }
      
      /// Process all packages in Shipment
      for packageInfo in optimalShipment.packages {
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
        
        let packageDeliveryTime = shipmentManager.calculatePackageDeliveryTime(vehicleSpeedInKmPerHr: allotedVehicle!.maxSpeedInKmPerHr, vehicleAccumulatedDeliveryTime: allotedVehicle!.accumulatedDeliveryTime, package: packageInfo)
        
        let packageCostWithTime = PackageCostWithTime(packageID: packageInfo.packageID,
                                                      discountAmount: discountAmount,
                                                      totalCost: originalDeliveryCost,
                                                      deliveryTime: packageDeliveryTime)
        
        outputDictionary[packageInfo.packageID] = packageCostWithTime
        
        tempPackageInfoArray = tempPackageInfoArray.filter({ $0.packageID != packageInfo.packageID })
      }
      
      /// Update vehicle array with total delivery time for alloted vehicle
      vehicleInfoArray[allotedVehicle!.id].accumulatedDeliveryTime += shipmentManager.calculateShipmentDeliveryTime(shipment: optimalShipment, vehicleSpeedInKmPerHr: allotedVehicle!.maxSpeedInKmPerHr)
      
    }
    
    /// parse output to match input order
    var resultArray = [PackageCostWithTime]()
    for packageInfo in packageInfoArray {
      if let packageCostTime = outputDictionary[packageInfo.packageID] {
        resultArray.append(packageCostTime)
      }
    }
    
    return resultArray
  }
  
}
