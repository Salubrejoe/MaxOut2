import Foundation
import HealthKit

final class HealthKitManager: ObservableObject {
  var store: HKHealthStore?
  
  
  // MARK: - TYPES
  let exerciseTimeType = HKQuantityType(.appleExerciseTime)
  let bodyMassType     = HKQuantityType(.bodyMass)
  let exerciseGoalType = HKObjectType.activitySummaryType()
  let workoutType      = HKSampleType.workoutType()
  
  var allTypes: Set<HKObjectType> {
    Set([
      exerciseTimeType,
      exerciseGoalType,
      bodyMassType,
      workoutType
    ])
  }
  
  
  // MARK: - STATS
  @Published var exerTimeGoal  : HKQuantity?
  @Published var exerTimeStats = [HealthStat]()
  @Published var bodyMassStats = [HealthStat]()
  @Published var activities    = [Activity]()
  
  var currentActivities: [Activity] {
    var current = [Activity]()
    for activity in activities {
      if activity.durationString != "" {
        current.append(activity)
      }
    }
    return current
  }
  
  
  // MARK: - COMPUTED STATS
  var exerTimeGoalDouble: Double {
    return exerTimeGoal?.doubleValue(for: .minute()) ?? 0
  }
  
  var exerTimeGoalString: String {
    String(format: "%0.f", exerTimeGoalDouble)
  }
  
  var maxWeight: Double {
    var weights: [Double] = []
    for stat in bodyMassStats {
      weights.append(stat.weight)
    }
    return weights.max() ?? 0
  }
  
  var minWeight: Double {
    var weights: [Double] = []
    for stat in bodyMassStats {
      weights.append(stat.weight)
    }
    return weights.min() ?? 0
  }
  
  var maxExerciseTime: Double {
    var min: [Double] = []
    for stat in exerTimeStats {
      min.append(stat.minutes/2)
    }
    return min.max() ?? 0
  }
  
  
  
  // MARK: - INIT
  init() {
    self.store = HKHealthStore()
    
    // 1. Request auth
    Task {
      do {
        try await store?.requestAuthorization(toShare: [], read: allTypes)
        start()
      }
      catch {
        print("Could not request auth: \(error)")
      }
    }
  }
  
  private func start() {
    getExerciseTime()
    getExerciseTimeGoal()
    getBodyMassStats()
    getActivities()
  }
}

// MARK: - GET STATS
extension HealthKitManager {
  
  // MARK: - EXERCISE TIME
  private func getExerciseTime() {
    guard let store else { return }
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .weekOfYear,
                                  value: -7,
                                  to: Date()) ?? Date()
    let endDate = Date()
    let anchorDate = Date.firstDayOfWeek()
    let dailyComponent = DateComponents(day: 2)
    
    var healthStats = [HealthStat]()
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    let query = HKStatisticsCollectionQuery(quantityType: exerciseTimeType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: dailyComponent)
    
    query.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
        let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
        healthStats.append(stat)
      })
      
      DispatchQueue.main.async {
        self.exerTimeStats = healthStats
      }
    }
    
    store.execute(query)
  }
  
  
  // MARK: - EXERCISE GOAL
  private func getExerciseTimeGoal() {
    guard let store else { return }
    let query = HKActivitySummaryQuery(predicate: createPredicate()) { (query, summariesOrNil, errorOrNil) -> Void in
      guard let summaries = summariesOrNil else { return }
      
      DispatchQueue.main.async {
        self.exerTimeGoal = summaries.last?.exerciseTimeGoal
      }
    }
    store.execute(query)
  }
  
  private func createPredicate() -> NSPredicate {
    let calendar = NSCalendar.current
    let endDate = Date()
    
    guard let startDate = calendar.date(byAdding: .day, value: -1, to: endDate) else {
      fatalError("*** Unable to create the start date ***")
    }
    
    
    let units: Set<Calendar.Component> = [.day, .month, .year, .era]
    
    
    var startDateComponents = calendar.dateComponents(units, from: startDate)
    startDateComponents.calendar = calendar
    
    
    var endDateComponents = calendar.dateComponents(units, from: endDate)
    endDateComponents.calendar = calendar
    
    let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: startDateComponents,
                                      end: endDateComponents)
    return predicate
  }
  
  
  // MARK: - BODY MASS
  private func getBodyMassStats() {
    guard let store else { return }
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .weekOfYear,
                                  value: -7,
                                  to: Date()) ?? Date()
    let endDate = Date()
    let anchorDate = Date.firstDayOfWeek()
    let dailyComponent = DateComponents(day: 1)
    
    var healthStats = [HealthStat]()
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    let query = HKStatisticsCollectionQuery(quantityType: bodyMassType, quantitySamplePredicate: predicate, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: dailyComponent)
    
    query.initialResultsHandler = { query, statistics, error in
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
    
    store.execute(query)
  }
  
  
  // MARK: - WORKOUTS
  private func getActivities() {
    for activityType in Activity.allActivities() {
      workouts(with: activityType) { stats in
        let activity = Activity(type: activityType, workouts: stats)
        DispatchQueue.main.async {
          self.activities.append(activity)
        }
      }
    }
  }
  
  private func workouts(with type: HKWorkoutActivityType, completion: @escaping ([HKWorkout]) -> ()) {
    guard let store else { return }
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .weekOfYear,
                                  value: -1,
                                  to: Date()) ?? Date()
    let endDate = Date()
    
    var workouts = [HKWorkout]()
    
    let timePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    let workoutPredicate = HKQuery.predicateForWorkouts(with: type)
    let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
    
    let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: 50, sortDescriptors: nil) { query, sample, error in
      guard let stats = sample as? [HKWorkout], error == nil  else {
        print("Troubles fetching workouts: \(String(describing: error))")
        return
      }
      for workout in stats {
        workouts.append(workout)
      }
      
      completion(workouts)
    }
    store.execute(query)
  }
}


// MARK: - Extension Date
extension Date {
  static func firstDayOfWeek() -> Date {
    let calendar =  Calendar(identifier: .iso8601)
    let components: Set<Calendar.Component> = [.yearForWeekOfYear, .weekOfYear]
    return calendar.date(from: calendar.dateComponents(components, from: Date())) ?? Date()
  }
}


