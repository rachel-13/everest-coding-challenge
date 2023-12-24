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
    let weightArr = [50, 75, 175, 110, 155]
    let maxWeight = 200
    
    let packageBundle = getOptimalPackageBundle(maxWeight: maxWeight, weightArr: weightArr)
  }
  
  func getOptimalPackageBundle(maxWeight:Int, weightArr:[Int]) -> [Int] {
    var countTable = Array(repeating: Array(repeating: -1, count: maxWeight+1), count: weightArr.count+1)
    var weightTable = Array(repeating: Array(repeating: -1, count: maxWeight+1), count: weightArr.count+1)
    var selectedItemsTable = Array(repeating: Array(repeating: [Int](), count: maxWeight+1), count: weightArr.count+1)
    
    for item in 0...weightArr.count {
      for weightCap in 0...maxWeight {

        if item == 0 || weightCap == 0 {
          countTable[item][weightCap] = 0
          weightTable[item][weightCap] = 0
        } else if weightArr[item - 1] <= weightCap {
          
          let notIncludeCurrentItemWeight = weightTable[item - 1][weightCap]
          let includeCurrentItemWeight = weightArr[item - 1] + weightTable[item - 1][weightCap - weightArr[item - 1]]
          
          let notIncludeCurrentItem = countTable[item - 1][weightCap]
          let includeCurrentItem = 1 + countTable[item - 1][weightCap - weightArr[item - 1]]
          
          if includeCurrentItem > notIncludeCurrentItem {
            countTable[item][weightCap] = includeCurrentItem
            weightTable[item][weightCap] = includeCurrentItemWeight
            
            if countTable[item - 1][weightCap - weightArr[item - 1]] != 0 {
              selectedItemsTable[item][weightCap] = selectedItemsTable[item - 1][weightCap - weightArr[item - 1]] + [item - 1]
            } else {
              selectedItemsTable[item][weightCap].append(item - 1)
            }
            
          } else if notIncludeCurrentItem == includeCurrentItem && includeCurrentItemWeight > notIncludeCurrentItemWeight {
            countTable[item][weightCap] = includeCurrentItem
            weightTable[item][weightCap] = includeCurrentItemWeight
            
            if countTable[item - 1][weightCap - weightArr[item - 1]] != 0 {
              selectedItemsTable[item][weightCap] = selectedItemsTable[item - 1][weightCap - weightArr[item - 1]] + [item - 1]
            } else {
              selectedItemsTable[item][weightCap].append(item - 1)
            }
          } else {
            countTable[item][weightCap] = notIncludeCurrentItem
            weightTable[item][weightCap] = notIncludeCurrentItemWeight
            selectedItemsTable[item][weightCap] = selectedItemsTable[item - 1][weightCap]
          }
          
        } else {
          countTable[item][weightCap] = countTable[item - 1][weightCap]
          weightTable[item][weightCap] = weightTable[item - 1][weightCap]
          selectedItemsTable[item][weightCap] = selectedItemsTable[item - 1][weightCap]
        }
      }
    }
    
    return selectedItemsTable[weightArr.count][maxWeight]
  }
}
