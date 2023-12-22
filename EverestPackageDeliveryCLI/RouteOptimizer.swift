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
    
//    let result = findSubsetsLessThanMaxWeight(arr: arr, maxWeight: max)
//    let result = subsets(arr).filter { currArr in
//      return currArr.reduce(0, +) <= max
//    }.sorted { lhs, rhs in
//      return lhs.count > rhs.count
//    }
    
//    print(result)
    
    generateDynamicProgrammingTable(maxWeight: maxWeight, weightArr: weightArr)
  }
  
  func findSubsetsLessThanMaxWeight(arr: [Int], maxWeight: Int) -> [[Int]] {
    
    var subsetsWithinCapacity = [[Int]]()
    
    
    
    return subsetsWithinCapacity
  }
  
//  func subsets(_ nums: [Int]) -> [[Int]] {
//    var results: [[Int]] = []
//    if nums.count == 0 {
//      return results
//    }
//    
//    results.append([])
//    
//    for i in stride(from: 0, to: nums.count, by: 1) {
//      let count = results.count
//      for j in stride(from: 0, to: count, by: 1) {
//        results.append(results[j] + [nums[i]])
//      }
//    }
//    
//    return results
//  }
  
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
