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
  
  init() {
    
  }
  
  func run() {
    #if !TEST
    promptForInput()
    #endif
  }
  
  private func promptForInput() {
    print("Welcome to Package Delivery system. Type 'quit' to exit.")
    while let line = readLine() {
      
      if line == "quit" {
        print("Exiting program...")
        break
      }
      
      if !isMetadataSet {
        setupMetadata(line: line)
      } else {
        // TODO: setup package info
      }
    }
  }
  
  func setupMetadata(line: String) {
    let userInputArr = line.components(separatedBy: " ")
    
    guard userInputArr.count == 2 else  {
      return
    }
    
    guard let baseWeight = Int(userInputArr[0]), let numberOfPackages = Int(userInputArr[1]) else {
      return
    }
    
    self.baseWeight = baseWeight
    self.numberOfPackages = numberOfPackages
    
    isMetadataSet = true
  }
  
}

let packageDelivery = PackageDelivery()
packageDelivery.run()
