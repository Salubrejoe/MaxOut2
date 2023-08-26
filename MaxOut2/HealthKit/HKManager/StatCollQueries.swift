import Foundation
import HealthKit

extension HealthKitManager {
  
  func getWeightStats() {
    performStatisticCollection(bodyMassType)
  }
  func getHeightStats() {
    performStatisticCollection(heightType)
  }
  
  private func performStatisticCollection(_ type: HKQuantityType) {
    guard let store else { return }
    
    var healthStats = [HealthStatQuantity]()
    
    let resolution = self.timeRange.resolution
    let startDate = self.timeRange.startDate
    let anchorDate = Date.firstDayOfWeek()
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())
    
    
    let query = HKStatisticsCollectionQuery(quantityType: type,
                                            quantitySamplePredicate: predicate,
                                            options: .discreteAverage,
                                            anchorDate: anchorDate,
                                            intervalComponents: DateComponents(day: resolution))
    
    query.initialResultsHandler = { query, statistics, error in
      
      statistics?.enumerateStatistics(from: startDate, to: Date()) { stats, _ in
        
        let stat = HealthStatQuantity(stat: stats.averageQuantity(), date: stats.startDate)
        if stat.stat != nil {
          healthStats.append(stat)
        }
      }
      
      DispatchQueue.main.async {
        self.save(healthStats, to: type)
      }
    }
    
    store.execute(query)
  }
  
  private func save(_ healthStats: [HealthStatQuantity], to type: HKQuantityType) {
    switch type {
      case HKQuantityType(.bodyMass)          : self.bodyMassStats = healthStats
      case HKQuantityType(.height)            : self.heightStats   = healthStats
      default : print("ERROR SAVING HEALTH STATS")
    }
  }
}
