import Foundation
import HealthKit

final class HKRepo {
  var store: HKHealthStore?
  
  let allTypes = Set([
    HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
  ])
  
  var query: HKStatisticsCollectionQuery?
  
  init() {
    self.store = HKHealthStore()
  }
  
  // 1. Request Authorization
  func requestAuthorization(completion: @escaping (Bool) -> ()) {
    guard let store else { return }
    
    store.requestAuthorization(toShare: [], read: allTypes) { success, error in
      completion(success)
    }
  }
  
  // 2. Get the Health stat from provided category
  func requestHealthStat(completion: @escaping ([HealthStat]) -> ()) {
    guard let store, let type = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else { return }
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .day,
                                  value: -7,
                                  to: Date()) ?? Date()
    let endDate = Date()
    let anchorDate = Date.firstDayOfWeek()
    let dailyComponent = DateComponents(day: 1)
    
    var healthStats = [HealthStat]()
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: dailyComponent)
    
    query?.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
        let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
        healthStats.append(stat)
      })
      
      completion(healthStats)
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

