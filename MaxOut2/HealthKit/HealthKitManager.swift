import Foundation
import HealthKit


// MARK: - HEALTH QUERY
struct HealthStatsQuery {
  let timeRange  : TimeRange
  let type       : HKQuantityType
  var options : HKStatisticsOptions {
    switch type {
      case HKQuantityType(.appleExerciseTime) : return .cumulativeSum
      case HKQuantityType(.bodyMass) : return .discreteAverage
      case HKQuantityType(.height) : return .discreteAverage
      default : return .mostRecent
    }
  }
}



final class HealthKitManager: ObservableObject {
  var store: HKHealthStore?
  
  // MARK: - TYPES
  let exerciseTimeType = HKQuantityType(.appleExerciseTime)
  let bodyMassType     = HKQuantityType(.bodyMass)
  let heightType       = HKQuantityType(.height)
  let exerciseGoalType = HKObjectType.activitySummaryType()
  let workoutType      = HKSampleType.workoutType()
  
  var allTypes: Set<HKObjectType> {
    Set([
      exerciseTimeType,
      exerciseGoalType,
      bodyMassType,
      heightType,
      workoutType
    ])
  } 
  
  var shareTypes: Set<HKSampleType> {
    Set([
//      exerciseTimeType,
      bodyMassType,
      heightType,
      workoutType
    ])
  }
  
  
  // MARK: - STATS
  @Published var exerTimeGoal  : HealthStat?
  @Published var exerTimeStats = [HealthStat]()
  @Published var bodyMassStats = [HealthStat]()
  @Published var heightStats   = [HealthStat]()
  
  var allActivities: [Activity] = [
    Activity(name: .elliptical),
    Activity(name: .traditionalStrengthTraining),
    Activity(name: .coreTraining),
    Activity(name: .walking),
    Activity(name: .running),
    Activity(name: .rowing),
    Activity(name: .highIntensityIntervalTraining),
    Activity(name: .wheelchairRunPace),
    Activity(name: .skatingSports),
    Activity(name: .flexibility),
    Activity(name: .jumpRope),
    Activity(name: .mixedCardio),
  ]
  
  
  // MARK: - T RANGE
  @Published var timeRange : TimeRange = .M
  
  
  // MARK: - INIT
  init() {
    self.store = HKHealthStore()
    
    // 1. Request auth
    Task {
      do {
        try await store?.requestAuthorization(toShare: shareTypes, read: allTypes)
      }
      catch {
        print("Could not request auth: \(error)")
      }
    }
  }
  
  func start() {
    getStats()
    getExerciseTimeGoal()
    getActivities(last: 7)
  }
}


// MARK: - COMPUTED STATS
extension HealthKitManager {
  var currentActivities: [Activity] {
    var current = [Activity]()
    for activity in allActivities {
      if activity.durationString != ("", "00") {
        current.append(activity)
      }
    }
    return current.sorted { $0.duration > $1.duration }
  }
  
  var exerTimeGoalDouble: Double {
    guard let exerTimeGoal else { return 0 }
    if let stat = exerTimeGoal.stat {
      return stat.doubleValue(for: .minute())
    }
    return 0
  }
  
  var exerTimeGoalString: String {
    String(format: "%0.f", exerTimeGoalDouble)
  }
  
  var heightProfileString: String {
    guard let something = heightStats.last else { return "" }
    return "📏\(something.heightString) meters tall"
  }
  
  var heightString: String {
    guard let something = heightStats.last else { return "" }
    return "\(something.heightString) m"
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
      min.append(stat.minutes/Double(timeRange.resolution))
    }
    return min.max() ?? 0
  }
}


// MARK: - QUERY STATS
extension HealthKitManager {
  func getStats() {
    getExerciseTimeStats()
    getWeightStats()
    getHeightStats()
  }
  
  func getExerciseTimeStats() {
    let query = HealthStatsQuery(timeRange: timeRange, type: exerciseTimeType)
    perform(query)
  }
  
  func getWeightStats() {
    let query = HealthStatsQuery(timeRange: timeRange, type: bodyMassType)
    perform(query)
  }
  
  func getHeightStats() {
    let query = HealthStatsQuery(timeRange: timeRange, type: heightType)
    perform(query)
  }
  
  
  // MARK: - PERFORM QUERY
  func perform(_ hSQuery: HealthStatsQuery) {
    guard let store else { return }
    
    var healthStats = [HealthStat]()
    
    let resolution = hSQuery.timeRange.resolution
    let startDate = hSQuery.timeRange.startDate
    let anchorDate = Date.firstDayOfWeek()
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())
    
    let query = HKStatisticsCollectionQuery(quantityType: hSQuery.type,
                                            quantitySamplePredicate: predicate,
                                            options: hSQuery.options,
                                            anchorDate: anchorDate,
                                            intervalComponents: DateComponents(day: resolution))
    
    query.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: startDate, to: Date(), with: { stats, _ in
        
        let stat = HealthStat(stat: self.rightStatistics(stats, for: hSQuery.type), date: stats.startDate)
        if hSQuery.type != self.bodyMassType {
          healthStats.append(stat)
        }
        else if stat.stat != nil {
          healthStats.append(stat)
        }
      })
      
      DispatchQueue.main.async {
        self.save(healthStats, to: hSQuery.type)
      }
    }
    
    store.execute(query)
  }
  
  private func rightStatistics(_ stats: HKStatistics, for type: HKQuantityType) -> HKQuantity? {
    switch type {
      case HKQuantityType(.appleExerciseTime) : return stats.sumQuantity()
      default : return stats.averageQuantity()
    }
  }
  
  private func save(_ healthStats: [HealthStat], to type: HKQuantityType) {
    switch type {
      case HKQuantityType(.appleExerciseTime) : self.exerTimeStats = healthStats
      case HKQuantityType(.bodyMass)          : self.bodyMassStats = healthStats
      case HKQuantityType(.height)            : self.heightStats   = healthStats
      default : print("ERROR SAVING HEALTH STATS")
    }
  }
  
  // MARK: - EXERCISE GOAL
  func getExerciseTimeGoal() {
    self.exerTimeGoal = nil
    
    guard let store else { return }
    let query = HKActivitySummaryQuery(predicate: createPredicate()) { (query, summariesOrNil, errorOrNil) -> Void in
      guard let summaries = summariesOrNil else { return }
      let stat = HealthStat(stat: summaries.last?.exerciseTimeGoal ?? nil,
                            date: Date())
      DispatchQueue.main.async {
        self.exerTimeGoal = stat
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
}


// MARK: - ACTIVITIES
extension HealthKitManager {
  
  func getActivities(last interval: Int) {
    for index in allActivities.indices {
      workouts(with: allActivities[index].hkType, last: interval) { workouts in
        self.allActivities[index].workouts = workouts
      }
    }
  }
  
  private func workouts(with type: HKWorkoutActivityType, last interval: Int, completion: @escaping ([HKWorkout]) -> ()) {
    guard let store else { return }
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .day,
                                  value: -interval,
                                  to: Date()) ?? Date()
    let endDate = Date()
    
    var workouts = [HKWorkout]()
    
    let timePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    let workoutPredicate = HKQuery.predicateForWorkouts(with: type)
    let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
    
    let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: 0, sortDescriptors: nil) { query, sample, error in
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

// MARK: - SUBMIT STATS
extension HealthKitManager {
  
  func submit(weight: Double) {
    guard let store else { return }
    
    let quantityType = HKQuantityType(.bodyMass)
    
    let quantity = HKQuantity.init(unit: HKUnit.gramUnit(with: .kilo), doubleValue: weight)
    
    let bodyMass = HKQuantitySample(type: quantityType,
                                    quantity: quantity,
                                    start: Date(),
                                    end: Date())
    store.save(bodyMass) { success, error in
      guard error == nil else {
        print("Error saving weight: \n \(error?.localizedDescription))")
        return
      }
      
      if success { print("Saved! 😄 \(success)")}
    }
    getWeightStats()
  }
  
  func submit(height: Double) {
    guard let store else { return }
    
    let quantityType = HKQuantityType(.height)
    
    let quantity = HKQuantity.init(unit: HKUnit.meter(), doubleValue: height)
    
    let bodyMass = HKQuantitySample(type: quantityType,
                                    quantity: quantity,
                                    start: Date(),
                                    end: Date())
    store.save(bodyMass) { success, error in
      guard error == nil else {
        print("Error saving height: \n \(error?.localizedDescription))")
        return
      }
      
      if success { print("Saved Height! 😄 \(success)")}
    }
    
    getHeightStats()
  }
}





/*
 OBSOLETE??
 // MARK: - HEIGHT
 //  func getHeight() {
 //    self.heightStats = []
 //
 //    guard let store else { return }
 //    let calendar = Calendar.current
 //    let startDate = calendar.date(byAdding: .year,
 //                                  value: -12,
 //                                  to: Date()) ?? Date()
 //
 //    let endDate = Date()
 //    let anchorDate = Date.firstDayOfWeek()
 //    let dailyComponent = DateComponents(day: 10)
 //
 //    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
 //
 //    var healthStats = [HealthStat]()
 //
 //    let query = HKStatisticsCollectionQuery(quantityType: heightType, quantitySamplePredicate: predicate, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: dailyComponent)
 //
 //    query.initialResultsHandler = { query, statistics, error in
 //      statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
 //        let stat = HealthStat(stat: stats.averageQuantity(), date: stats.startDate)
 //        if stat.stat != nil {
 //          healthStats.append(stat)
 //        }
 //      })
 //
 //      DispatchQueue.main.async {
 //        self.heightStats = healthStats
 //      }
 //    }
 //    store.execute(query)
 //  }
 
 // MARK: - BODY MASS
 //  func getBodyMassStats() {
 //    guard let store else { return }
 //
 //    let calendar = Calendar.current
 //    let startDate = calendar.date(byAdding: .weekOfYear,
 //                                  value: -7,
 //                                  to: Date()) ?? Date()
 //    let endDate = Date()
 //    let anchorDate = Date.firstDayOfWeek()
 //    let dailyComponent = DateComponents(day: 1)
 //
 //    var healthStats = [HealthStat]()
 //
 //    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
 //
 //    let query = HKStatisticsCollectionQuery(quantityType: bodyMassType, quantitySamplePredicate: predicate, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: dailyComponent)
 //
 //    query.initialResultsHandler = { query, statistics, error in
 //      guard let statistics else { return }
 //      statistics.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
 //        let stat = HealthStat(stat: stats.averageQuantity(), date: stats.startDate)
 //        if stat.stat != nil {
 //          healthStats.append(stat)
 //        }
 //      })
 //      DispatchQueue.main.async {
 //        self.bodyMassStats = healthStats
 //      }
 //    }
 //
 //    store.execute(query)
 //  }
 
 
 // MARK: - EXERCISE TIME
 //  @MainActor
 //  func getExerciseTime(_ exQuery: HealthStatsQuery) {
 //
 //    guard let store else { return }
 //
 //    let calendar = Calendar.current
 //    let endDate = Date()
 //    let anchorDate = Date.firstDayOfWeek()
 //    let dailyComponent = DateComponents(day: exQuery.resolution)
 //
 //    var healthStats = [HealthStat]()
 //
 //    let predicate = HKQuery.predicateForSamples(withStart: exQuery.startDate, end: endDate)
 //
 //    let query = HKStatisticsCollectionQuery(quantityType: exerciseTimeType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: dailyComponent)
 //
 //    query.initialResultsHandler = { query, statistics, error in
 //      statistics?.enumerateStatistics(from: exQuery.startDate, to: endDate, with: { stats, _ in
 //        let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
 //        healthStats.append(stat)
 //      })
 //
 //      DispatchQueue.main.async {
 //        self.exerTimeStats = healthStats
 //      }
 //    }
 //
 //    store.execute(query)
 //  }
 */
