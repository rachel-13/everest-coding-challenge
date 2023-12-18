//
//  MockErrorHandler.swift
//  EverestPackageDeliveryCLITests
//
//  Created by pohz on 18/12/2023.
//

import Foundation

final class MockErrorHandler: ErrorHandlerProtocol {
  
  var didCallDisplayError = false
  var stubbedError: SystemError?
  func displayError(error: SystemError) {
    didCallDisplayError = true
    stubbedError = error
  }
}
