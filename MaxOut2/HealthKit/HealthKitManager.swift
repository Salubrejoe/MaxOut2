import Foundation
import HealthKit

final class HealthKitManager: ObservableObject {
  var store: HKHealthStore?
  
  let allTypes = Set([
    HKQuantityType(.appleExerciseTime),
    HKQuantityType(.bodyMass),
  ])
  
  var query: HKStatisticsCollectionQuery?
  
  @Published var exerTimeStats = [HealthStat]()
  @Published var bodyMassStats = [HealthStat]()
  
  var maxWeight: Double {
    var weights: [Double] = []
    for stat in bodyMassStats { 
      weights.append(stat.weight)
    }
    return weights.max() ?? 0
  }
  
  var maxExerciseTime: Double {
    var min: [Double] = []
    for stat in exerTimeStats {
      print(stat)
      min.append(stat.minutes/2)
    }
    return min.max() ?? 0
  }
  
  init() {
    self.store = HKHealthStore()
    
    // 1. Request auth
    Task {
      do {
        try await store?.requestAuthorization(toShare: [], read: allTypes)
      }
      catch {
        print("Could not request auth: \(error)")
      }
    }
    
    getExerciseTime()
    getBodyMassStats()
  }
  
  // 2. Get the Health stat from provided category
  func getExerciseTime() {
    guard let store else { return }
    
    let type = HKQuantityType(.appleExerciseTime)
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .weekOfYear,
                                  value: -7,
                                  to: Date()) ?? Date()
    let endDate = Date()
    let anchorDate = Date.firstDayOfWeek()
    let dailyComponent = DateComponents(day: 2)
    
    var healthStats = [HealthStat]()
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: dailyComponent)
    
    query?.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
        let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
        healthStats.append(stat)
      })
      
      DispatchQueue.main.async {
        self.exerTimeStats = healthStats
      }
    }
    
    guard let query else { return }
    store.execute(query)
  }
  
  func getBodyMassStats() {
    guard let store else { return }
    
    let type = HKQuantityType(.bodyMass)
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .weekOfYear,
                                  value: -7,
                                  to: Date()) ?? Date()
    let endDate = Date()
    let anchorDate = Date.firstDayOfWeek()
    let dailyComponent = DateComponents(day: 1)
    
    var healthStats = [HealthStat]()
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: dailyComponent)
    
    query?.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
        let stat = HealthStat(stat: stats.averageQuantity(), date: stats.startDate)
        if stat.stat != nil {
          healthStats.append(stat)
        }
      })
      
      DispatchQueue.main.async {
        self.bodyMassStats = healthStats
      }
    }
    
    guard let query else { return }
    store.execute(query)
  }
}

extension Date {
  static func firstDayOfWeek() -> Date {
    let calendar =  Calendar(identifier: .iso8601)
    let components: Set<Calendar.Component> = [.yearForWeekOfYear, .weekOfYear]
    return calendar.date(from: calendar.dateComponents(components, from: Date())) ?? Date()
  }
}



/*
 BAFORE SAVING DATA CALL authorizationStatus(for:)
 */

