import Foundation
import HealthKit

struct HealthStatsQuantityQuery {
  var timeRange  : TimeRange
  var type       : HKQuantityType
  var options    : HKStatisticsOptions {
    switch type {
      case HKQuantityType(.appleExerciseTime)  : return .cumulativeSum
      case HKQuantityType(.activeEnergyBurned) : return .cumulativeSum
      case HKQuantityType(.appleStandTime)     : return .cumulativeSum
      case HKQuantityType(.bodyMass) : return .discreteAverage
      case HKQuantityType(.height)   : return .discreteAverage
      default : return .mostRecent
    }
  }
  
  func rightStatistics(_ stats: HKStatistics) -> HKQuantity? {
    switch type {
      case HKQuantityType(.activeEnergyBurned), HKQuantityType(.appleExerciseTime), HKQuantityType(.appleStandTime):
        return stats.sumQuantity()
      default:
        return stats.averageQuantity()
    }
  }
}
