//
//  main.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 15/12/2023.
//

import Foundation

class PackageDelivery {
  
  var isMetadataSet = false
  var numberOfPackages: Int?
  var baseWeight: Int?
  var errorHandler: ErrorHandlerProtocol
  
  init(errorHandler: ErrorHandlerProtocol) {
    self.errorHandler = errorHandler
  }
  
  func run() {
    #if !TEST
    promptForInput()
    #endif
  }
  
  private func promptForInput() {
    print("Type 'quit' to exit.\nPlease enter base weight in KG and number of packages.")
    
    while let line = readLine() {
      if line == "quit" {
        print("Exiting program...")
        break
      }
      
      if !isMetadataSet {
        handleMetadata(line: line)
      } else {
        // TODO: setup package info
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
      throw SystemError.incorrectArgument
    }
    
    guard let baseWeight = Int(userInputArr[0]), let numberOfPackages = Int(userInputArr[1]) else {
      throw SystemError.incorrectDataType
    }
    
    self.baseWeight = baseWeight
    self.numberOfPackages = numberOfPackages
    
    isMetadataSet = true
  }
}


let errorHandler = ErrorHandler()
let packageDelivery = PackageDelivery(errorHandler: errorHandler)
packageDelivery.run()
