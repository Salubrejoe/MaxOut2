import Foundation
import HealthKit

enum TimeRange: String, CaseIterable, Identifiable {
  case W  = "W"
  case TW = "TW"
  case M  = "M"
  case SM = "6M"
  case Y  = "Y"
  var id: TimeRange { self }
  
  var query: ExerciseQuery {
    switch self {
      case .W :
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .weekOfYear,
                                      value: -1,
                                      to: Date()) ?? Date()
        return ExerciseQuery(resolution: 1, startDate: startDate)
      case .TW :
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .weekOfYear,
                                      value: -2,
                                      to: Date()) ?? Date()
        return ExerciseQuery(resolution: 1, startDate: startDate)
      case .M :
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month,
                                      value: -1,
                                      to: Date()) ?? Date()
        return ExerciseQuery(resolution: 1, startDate: startDate)
      case .SM :
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month,
                                      value: -6,
                                      to: Date()) ?? Date()
        return ExerciseQuery(resolution: 7, startDate: startDate)
      case .Y :
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month,
                                      value: -12,
                                      to: Date()) ?? Date()
        return ExerciseQuery(resolution: 30, startDate: startDate)
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
  @Published var exerTimeGoal  : HKQuantity?
  @Published var exerTimeStats = [HealthStat]()
  @Published var bodyMassStats = [HealthStat]()
  @Published var heightStats   = [HealthStat]()
  @Published var activities    = [Activity]()
  
  
  // MARK: - QUERY PROPERTIES
  @Published var timeRange: TimeRange = .M
  var startDate = Date()
  var resolution = 1.0
  
  
  // MARK: - COMPUTED STATS
  var currentActivities: [Activity] {
    var current = [Activity]()
    for activity in activities {
      if activity.durationString != ("", "00") {
        current.append(activity)
      }
    }
    return current.sorted { $0.duration > $1.duration }
  }
  
  var exerTimeGoalDouble: Double {
    return exerTimeGoal?.doubleValue(for: .minute()) ?? 0
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
      min.append(stat.minutes/Double(resolution))
    }
    return min.max() ?? 0
  }
  
  
  
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
    getExerciseTime(timeRange.query)
    getExerciseTimeGoal()
    getBodyMassStats()
    getActivities(last: 7)
    getHeight()
  }
}


extension HealthKitManager {
  

  // MARK: - EXERCISE TIME
//  @MainActor
  func getExerciseTime(_ exQuery: ExerciseQuery) {
    
    guard let store else { return }
    
    let calendar = Calendar.current
    let endDate = Date()
    let anchorDate = Date.firstDayOfWeek()
    let dailyComponent = DateComponents(day: exQuery.resolution)
    
    var healthStats = [HealthStat]()
    
    let predicate = HKQuery.predicateForSamples(withStart: exQuery.startDate, end: endDate)
    
    let query = HKStatisticsCollectionQuery(quantityType: exerciseTimeType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: dailyComponent)
    
    query.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: exQuery.startDate, to: endDate, with: { stats, _ in
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
  func getExerciseTimeGoal() {
    self.exerTimeGoal = nil
    
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
  func getBodyMassStats() {
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
      guard let statistics else { return }
      statistics.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
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
  
  
  // MARK: - HEIGHT
  func getHeight() {
    self.heightStats = []
    
    guard let store else { return }
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .year,
                                  value: -12,
                                  to: Date()) ?? Date()
    
    let endDate = Date()
    let anchorDate = Date.firstDayOfWeek()
    let dailyComponent = DateComponents(day: 10)
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    var healthStats = [HealthStat]()
    
    let query = HKStatisticsCollectionQuery(quantityType: heightType, quantitySamplePredicate: predicate, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: dailyComponent)
    
    query.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
        let stat = HealthStat(stat: stats.averageQuantity(), date: stats.startDate)
        if stat.stat != nil {
          healthStats.append(stat)
        }
      })
      
      DispatchQueue.main.async {
        self.heightStats = healthStats
      }
    }
    store.execute(query)
  }
  
  
  // MARK: - WORKOUTS
  func getActivities(last interval: Int) {
    activities = []
    for activityType in Activity.tsActivities {
      workouts(with: activityType, last: interval) { stats in
        let activity = Activity(type: activityType, workouts: stats, exercises: nil)
        DispatchQueue.main.async {
          self.activities.append(activity)
        }
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

extension HealthKitManager {
  // MARK: - SUBMIT WEIGHT
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
        print("CATASTROPHIC FAILURE SAVING WEIGHT \n \(error))")
        return
      }
      
      if success { print("Saved! 😄 \(success)")}
    }
    getBodyMassStats()
  }
  
  // MARK: - SUBMIT HEIGHT
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
        print("CATASTROPHIC FAILURE SAVING Height \n \(error))")
        return
      }
      
      if success { print("Saved Height! 😄 \(success)")}
    }
    
    getHeight()
  }
}


// MARK: - Extension Date
extension Date {
  static func firstDayOfWeek() -> Date {
    let calendar =  Calendar(identifier: .iso8601)
    let components: Set<Calendar.Component> = [.yearForWeekOfYear, .weekOfYear]
    return calendar.date(from: calendar.dateComponents(components, from: Date())) ?? Date()
  }
  
  static func yesterday() -> Date {
    let calendar = Calendar.current
    let today = Date()
    
    // Define the date components for one day ago (yesterday)
    var dateComponents = DateComponents()
    dateComponents.weekOfYear = -4
    
    // Calculate yesterday's date using the calendar
    if let yesterday = calendar.date(byAdding: dateComponents, to: today) {
      return yesterday
    } else {
      // If there's an issue calculating the date, return today's date as a fallback
      return today
    }
  }

}


