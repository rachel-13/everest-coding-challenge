//
//  Offer.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 15/12/2023.
//

import Foundation

public struct Offer {
  let offerID: String
  let lowerBoundWeightInKg: Double
  let upperBoundWeightInKg: Double
  let lowerBoundDistanceInKm: Double
  let upperBoundDistanceInKm: Double
  let discountRateInPercent: Double
}
