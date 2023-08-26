import Foundation
import HealthKit

final class HealthKitManager: ObservableObject {
  var store: HKHealthStore?
  var errorMessage: String?
  let heartRateUnit: HKUnit = HKUnit(from: "count/min")
  
  private var allTypes: Set<HKObjectType> {
    Set([
      exerciseTimeType,
      activeEnergyBurnedType,
      standHoursType,
      ringGoalsType,
      bodyMassType,
      heightType,
      workoutType,
      heartRateType
    ])
  }
  
  private var shareTypes: Set<HKSampleType> {
    Set([
      bodyMassType,
      heightType,
      workoutType
    ])
  }
  
  // MARK: - TYPES
  let exerciseTimeType       = HKQuantityType(.appleExerciseTime)
  let activeEnergyBurnedType = HKQuantityType(.activeEnergyBurned)
  let standHoursType         = HKCategoryType(.appleStandHour)
  let ringGoalsType          = HKObjectType.activitySummaryType()
  let bodyMassType           = HKQuantityType(.bodyMass)
  let heightType             = HKQuantityType(.height)
  let heartRateType          = HKQuantityType(.heartRate)
  let workoutType            = HKSampleType.workoutType()
  
  // MARK: - STATS
  @Published var exerciseTimeGoal        : HealthStatQuantity?
  @Published var activeEnergyBurnedGoal  : HealthStatQuantity?
  @Published var standHoursGoal          : HealthStatQuantity?
  @Published var exerciseTimeStats       : [HealthStatQuantity]?
  @Published var activeEnergyBurnedStats : [HealthStatQuantity]?
  @Published var standHoursStats         : [HealthStatQuantity]?
  @Published var bodyMassStats           : [HealthStatQuantity]?
  @Published var heightStats             : [HealthStatQuantity]?
  @Published var representableWorkouts   : [RepresentableWorkout]?
  
  @Published var timeRange : TimeRange = .W
  
  
  // MARK: - INIT
  init() {
    self.store = HKHealthStore()
    
    Task {
      do {
        try await store?.requestAuthorization(toShare: shareTypes, read: allTypes)
        getStats()
      }
      catch {
        print("Could not request auth: \(error)")
      }
    }
  }
  
  func getStats() {
    getWeightStats()
    getHeightStats()
    getActivityRings()
    getRepresentableWorkouts()
  }
}
