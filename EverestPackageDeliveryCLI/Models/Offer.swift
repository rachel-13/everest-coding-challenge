//
//  Offer.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 15/12/2023.
//

import Foundation

struct Offer {
  let offerID: String
  let lowerBoundWeightInKg: Int
  let upperBoundWeightInKg: Int
  let lowerBoundDistanceInKm: Int
  let upperBoundDistanceInKm: Int
  let discountRateInPercent: Int
}
