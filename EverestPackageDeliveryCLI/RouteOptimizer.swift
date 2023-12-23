//
//  RouteOptimizer.swift
//  EverestPackageDeliveryCLI
//
//  Created by pohz on 19/12/2023.
//

import Foundation

@main
class RouteOptimizer {
  
  static func main() {
    
    // MARK: Program Setup and Entry Point
    
    let routeOptimizer = RouteOptimizer()
    routeOptimizer.run()
  }
  
  init() {
    
  }
  
  func run() {
    let weightArr = [50, 75, 175, 110, 155, 50]
    let maxWeight = 200
    
    generateDynamicProgrammingTable(maxWeight: maxWeight, weightArr: weightArr)
  }
  
  func generateDynamicProgrammingTable(maxWeight:Int, weightArr:[Int]) -> [[Int]] {
    var dpTable = Array(repeating: Array(repeating: -1, count: maxWeight+1), count: weightArr.count+1)
    
    for item in 0...weightArr.count {
      for weightCap in 0...maxWeight {

        if item == 0 || weightCap == 0 {
          dpTable[item][weightCap] = 0
        } else if weightArr[item - 1] <= weightCap {
          let maxValue = max(dpTable[item - 1][weightCap], weightArr[item - 1] + dpTable[item - 1][weightCap - weightArr[item - 1]])
          dpTable[item][weightCap] = maxValue
        } else {
          dpTable[item][weightCap] = dpTable[item - 1][weightCap]
        }
    
      }
    }
    
//    dpTable.forEach { currElement in
//      print(currElement)
//    }
    
    return dpTable
  }
}
