//
//  ErrorHandler.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 18/12/2023.
//

import Foundation

public enum SystemError: Error, Equatable {
  case incorrectArgumentMetadata
  case incorrectArgumentPackageInfo
  case incorrectDataType
  case negativeNumerics
}

public protocol ErrorHandlerProtocol {
  func displayError(error: SystemError)
}

class ErrorHandler: ErrorHandlerProtocol {
  public func displayError(error: SystemError) {
    switch error {
      case .incorrectArgumentMetadata:
        print("Please ensure there are 2 values in the input")
      case .incorrectArgumentPackageInfo:
        print("Please ensure there are at least 3 values in the input")
      case .incorrectDataType:
        print("Please ensure that the values are in the form of numbers")
      case .negativeNumerics:
        print("Please ensure numerics are postive values")
    }
  }
}