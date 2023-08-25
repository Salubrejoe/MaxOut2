import Foundation
import HealthKit

final class HealthKitManager: ObservableObject {
  var store: HKHealthStore?
  var errorMessage: String?
  let heartRateUnit:HKUnit = HKUnit(from: "count/min")
  
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
  @Published var exerciseTimeStats       = [HealthStatQuantity]()
  @Published var activeEnergyBurnedStats = [HealthStatQuantity]()
  @Published var standHoursStats         = [HealthStatQuantity]()
  @Published var bodyMassStats           = [HealthStatQuantity]()
  @Published var heightStats             = [HealthStatQuantity]()
  @Published var heartRate               = [HealthStatQuantity]()
  @Published var currentActivities       : [Activity]?
  
  
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
    
    getActivities { acts in
      self.currentActivities = acts
    }
    getActivityRings()
  }
}

// MARK: - HEART RATE
extension HealthKitManager {
  
  private func heartRate(for workout: HKWorkout) async throws -> [Double] {
    return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[Double],Error>) in
      getHeartRate(for: workout) { stats in
        if let stats { continuation.resume(returning: stats)}
        else { continuation.resume(throwing: URLError.errorDomain as! Error)}
      }
    })
  }
  
  private func getHeartRate(for workout: HKWorkout, completion: @escaping ([Double]?) -> ()){
    guard let store else {
      completion(nil)
      return
    }
    
    let start      = workout.startDate
    let end        = workout.endDate
    let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
    
    let query = HKSampleQuery(sampleType: heartRateType,
                              predicate: predicate,
                              limit: 0,
                              sortDescriptors: nil) { (query, results, error) in
      
      guard let results else { return }
      
      var heartRates = [Double]()
      for (_, sample) in results.enumerated() {
        guard let currentData: HKQuantitySample = sample as? HKQuantitySample else { return }
        
        let heartRate = currentData.quantity.doubleValue(for: self.heartRateUnit)
        heartRates.append(heartRate)
      }
      completion(heartRates)
    }
    store.execute(query)
  }
}


// MARK: - HEIGHT n WEIGHT
extension HealthKitManager {
  
  func getWeightStats() {
    let query = HealthStatsQuantityQuery(timeRange: timeRange, type: bodyMassType)
    performStatisticCollection(query)
  }
  func getHeightStats() {
    let query = HealthStatsQuantityQuery(timeRange: timeRange, type: heightType)
    performStatisticCollection(query)
  }
  
  private func performStatisticCollection(_ hSQuery: HealthStatsQuantityQuery) {
    guard let store else { return }
    
    var healthStats = [HealthStatQuantity]()
    
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
        
        let stat = HealthStatQuantity(stat: hSQuery.rightStatistics(stats), date: stats.startDate)
        
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
  
  private func save(_ healthStats: [HealthStatQuantity], to type: HKQuantityType) {
    switch type {
        //      case HKQuantityType(.appleExerciseTime) : self.exerciseTimeStats       = healthStats
        //      case HKQuantityType(.activeEnergyBurned): self.activeEnergyBurnedStats = healthStats
      case HKQuantityType(.bodyMass)          : self.bodyMassStats           = healthStats
      case HKQuantityType(.height)            : self.heightStats             = healthStats
      default : print("ERROR SAVING HEALTH STATS")
    }
  }
}


// MARK: - RINGS QUERY
extension HealthKitManager {
  
  func getActivityRings() {
    guard let store else { return }
    
    let query = HKActivitySummaryQuery(predicate: createPredicate(with: timeRange)) { (query, summariesOrNil, errorOrNil) -> Void in
      self.processResults(summariesOrNil)
    }
    store.execute(query)
  }
  
  private func processResults(_ summariesOrNil: [HKActivitySummary]?) {
    guard let summaries = summariesOrNil else { return }
    
    let moveTimeGoal = HealthStatQuantity(stat: summaries.last?.activeEnergyBurnedGoal, date: Date())
    let exerciseTimeGoal = HealthStatQuantity(stat: summaries.last?.exerciseTimeGoal, date: Date())
    let standTimeGoal = HealthStatQuantity(stat: summaries.last?.standHoursGoal, date: Date())
    
    var standingHours   = [HealthStatQuantity]()
    var exerciseMinutes = [HealthStatQuantity]()
    var activeEnergy    = [HealthStatQuantity]()
    
    for (index, summary) in summaries.reversed().enumerated() {
      let standingHour = HealthStatQuantity(stat: summary.appleStandHours, date: Date().minusDays(index))
      standingHours.append(standingHour)
      
      let exerciseMinute = HealthStatQuantity(stat: summary.appleExerciseTime, date: Date().minusDays(index))
      exerciseMinutes.append(exerciseMinute)
      
      let activeEn = HealthStatQuantity(stat: summary.activeEnergyBurned, date: Date().minusDays(index))
      activeEnergy.append(activeEn)
    }
    
    DispatchQueue.main.async {
      self.exerciseTimeGoal = exerciseTimeGoal
      self.activeEnergyBurnedGoal = moveTimeGoal
      self.standHoursGoal = standTimeGoal
      
      self.standHoursStats         = self.averagedStats(for: standingHours, unit: .count())
      self.exerciseTimeStats       = self.averagedStats(for: exerciseMinutes, unit: .minute())
      self.activeEnergyBurnedStats = self.averagedStats(for: activeEnergy, unit: .largeCalorie())
    }
  }
  
  private func averagedStats(for collection: [HealthStatQuantity], unit: HKUnit) -> [HealthStatQuantity] {
    switch timeRange.resolution {
      case 1  : return collection
      case 7  : return resolution(7, for: collection, unit: unit)
      case 30 : return resolution(30, for: collection, unit: unit)
      default : return []
    }
  }
  
  private func resolution(_ number: Int, for collection: [HealthStatQuantity], unit: HKUnit) -> [HealthStatQuantity] {
    
    var averagedValues = [HealthStatQuantity]()
    let numberOfChunks = collection.count / number
    
    for chunkIndex in 0..<numberOfChunks {
      let startIndex = chunkIndex * number
      let endIndex = min(startIndex + number, collection.count)
      let resolution = Array(collection[startIndex..<endIndex])
      
      var values: [Double] = []
      var date = Date()
      
      for e in resolution {
        let value = e.valueToAverage(unit: unit)
        values.append(value)
        date = e.date
      }
      
      let average = values.reduce(0.0, +) / Double(values.count)
      
      let stat = HKQuantity(unit: unit, doubleValue: average)
      
      let healthStatQuantity = HealthStatQuantity(stat: stat, date: date)
      
      averagedValues.append(healthStatQuantity)
    }
    
    return averagedValues
  }
  
  private func createPredicate(with timeRange: TimeRange, endDate: Date = Date()) -> NSPredicate {
    let calendar = NSCalendar.current
    let days = timeRange.numberOfDays - 1
    guard let startDate = calendar.date(byAdding: .day, value: -days, to: endDate) else {
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
  
  func getActivities(completion: @escaping ([Activity]) -> Void) {
    var acts = [Activity]()
    
    let group = DispatchGroup()
    
    for activity in allActivities {
      group.enter()
      let type = activity.type
      workouts(with: type, last: timeRange.numberOfDays) { [weak self] (workouts, error) in
        guard let workouts,
              let self,
              !workouts.isEmpty,
              error == nil else {
          group.leave()
          return
        }
        
        makeRepresentable(with: workouts) { representableWorkouts in
          let activity = Activity(type: type, workouts: representableWorkouts)
          acts.append(activity)
          group.leave()
        }
      }    }
    
    group.notify(queue: .main) {
      completion(acts)
    }
  }
  
  private func makeRepresentable(with workouts: [HKWorkout], completion: @escaping ([RepresentableWorkout]) -> Void) {
    
    let group = DispatchGroup()
    
    var representableWorkouts = [RepresentableWorkout]()
    for workout in workouts {
      
      group.enter()
      self.getHeartRate(for: workout) { stats in
        
        guard let stats else { return }
        let representableWorkout = RepresentableWorkout(id: workout.uuid.uuidString,
                                                        start: workout.startDate,
                                                        end: workout.endDate,
                                                        duration: workout.duration,
                                                        heartRateValues: stats)
        
        representableWorkouts.append(representableWorkout)
        group.leave()
      }
    }
    group.notify(queue: .main) {
      // This closure will be called when all async operations are complete
      completion(representableWorkouts)
    }
  }
  
  private func workouts(with type: HKWorkoutActivityType,
                        last interval: Int,
                        completion: @escaping ([HKWorkout]?, Error?) -> ()) {
    guard let store else { return }
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .day,
                                  value: -interval,
                                  to: Date()) ?? Date()
    let endDate = Date()
    
    let timePredicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)
    let workoutPredicate = HKQuery.predicateForWorkouts(with: type)
    
    ///from kodeco: HKSource denotes the app that provided the workout data to HealthKit.
    ///Whenever you call HKSource.default(), you’re saying “this app.” sourcePredicate gets all workouts where the source is, you guessed it, this app.
    ///
    ///let sourcePredicate = HKQuery.predicateForObjects(from: .default())
    
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                          ascending: true)
    let query = HKSampleQuery(
      sampleType: workoutType,
      predicate: compoundPredicate,
      limit: 0,
      sortDescriptors: [sortDescriptor]) { (query, sample, error) in
        
        guard let sample = sample as? [HKWorkout],
              error == nil  else {
          completion(nil, error)
          return
        }
        
        completion(sample, nil)
      }
    store.execute(query)
  }
}


// MARK: - SAVE WORKOUT
extension HealthKitManager {
  
  func saveWorkout(start: Date,
                   end: Date,
                   activityType: ActivityType) {
    guard let store, HKHealthStore.isHealthDataAvailable() else {
      print("HealthKit is not available on this device.")
      return
    }
    
    let startInt = start.timeIntervalSince1970
    let endInt = end.timeIntervalSince1970
    let duration = endInt - startInt
    
    let workout = HKWorkout(activityType: activityType.hkType,
                            start: start,
                            end: end,
                            duration: duration,
                            totalEnergyBurned: nil,
                            totalDistance: nil,
                            metadata: nil)
    
    store.save(workout) { (success, error) -> Void in
      guard success else {
        print("Mistakes in HK - saveWorkouts()")
        return
      }
    }
  }
}


// MARK: - SUBMIT STATS
extension HealthKitManager {
  
  func submit(weight: Double) {
    guard let store else { return }
    
    let quantityType = HKQuantityType(.bodyMass)
    
    let quantity = HKQuantity.init(unit: HKUnit.gramUnit(with: .kilo),
                                   doubleValue: weight)
    
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
    
    let quantity = HKQuantity.init(unit: HKUnit.meter(),
                                   doubleValue: height)
    
    
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





// MARK: - COMPUTED STATS
extension HealthKitManager {
  
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
  
  public var allActivities: [Activity] {
    var activities = [Activity]()
    for activity in HKWorkoutActivityType.allCases {
      activities.append(Activity(type: activity))
    }
    return activities
  }
  
  public var favouriteActivities: [Activity] {
    allActivities.filter { $0.isFavorite }
  }
  
  public var exerTimeGoalDouble: Double {
    guard let exerciseTimeGoal else { return 0 }
    if let stat = exerciseTimeGoal.stat {
      return stat.doubleValue(for: .minute())
      
    }
    return 0
  }
  
  public var exerTimeGoalString: String {
    String(format: "%0.f", exerTimeGoalDouble)
  }
  
  public var activeEnergyBurnedGoalDouble: Double {
    guard let activeEnergyBurnedGoal else { return 0 }
    if let stat = activeEnergyBurnedGoal.stat {
      return stat.doubleValue(for: .largeCalorie())
    }
    return 0
  }
  
  public var activeEnergyBurnedGoalString: String {
    String(format: "%0.f", activeEnergyBurnedGoalDouble)
  }
  
  public var standTimeGoalDouble: Double {
    guard let standHoursGoal else { return 0 }
    if let stat = standHoursGoal.stat {
      return stat.doubleValue(for: .count())
    }
    return 0
  }
  
  public var standTimeGoalString: String {
    String(format: "%0.f", standTimeGoalDouble)
  }
  
  public var heightProfileString: String {
    guard let something = heightStats.last else { return "" }
    return "📏\(something.heightString) meters tall"
  }
  
  public var heightString: String {
    guard let something = heightStats.last else { return "" }
    return "\(something.heightString) m"
  }
  
  public var maxWeight: Double {
    var weights: [Double] = []
    for stat in bodyMassStats {
      weights.append(stat.weight ?? 0)
    }
    return weights.max() ?? 0
  }
  
  public var minWeight: Double {
    var weights: [Double] = []
    for stat in bodyMassStats {
      weights.append(stat.weight ?? 0)
    }
    return weights.min() ?? 0
  }
  
  public var maxExerciseTime: Double {
    var min: [Double] = []
    for stat in exerciseTimeStats {
      min.append((stat.minutes ?? 0)/Double(timeRange.resolution))
    }
    return min.max() ?? 0
  }
}




// MARK: - Extension Date()
extension Date {
  func minusDays(_ number: Int) -> Date {
    Calendar.current.date(byAdding: .day, value: -number, to: self) ?? self
  }
}
