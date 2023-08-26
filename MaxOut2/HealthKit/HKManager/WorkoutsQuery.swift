import HealthKit
import Foundation

extension HealthKitManager {
  
  func getRepresentableWorkouts() {
    var rWorkouts = [RepresentableWorkout]()
    
    let group = DispatchGroup()
    
    for type in HKWorkoutActivityType.allCases {
      group.enter()
      workouts(with: type, last: timeRange.numberOfDays) { [weak self] (workouts, error) in
        guard let workouts,
              let self,
              !workouts.isEmpty,
              error == nil else {
          group.leave()
          return
        }
        
        makeRepresentable(with: workouts) { representableWorkouts in
          rWorkouts += representableWorkouts
          group.leave()
        }
      }
    }
    
    group.notify(queue: .main) {
      DispatchQueue.main.async {
        self.representableWorkouts = rWorkouts
      }
    }
  }
  
  
  // MARK: - MAKE WORKOUTS
  private func makeRepresentable(with workouts: [HKWorkout], completion: @escaping ([RepresentableWorkout]) -> Void) {
    
    let group = DispatchGroup()
    
    var representableWorkouts = [RepresentableWorkout]()
    for workout in workouts {
      
      group.enter()
      self.getHeartRate(for: workout) { heartRateStats in
        
        var distance = 0.0
        
        if let distanceStats = workout.statistics(for: HKQuantityType(.distanceWalkingRunning)),
           let dist = distanceStats.sumQuantity(){
          distance = dist.doubleValue(for: .meter())
        }
        
        
        let group2 = DispatchGroup()
        
        guard let heartRateStats else { return }
        
        var activeKcals = [Double]()
        
        group2.enter()
        self.getKcal(for: workout) { activeKcalStats in
          guard let activeKcalStats else { return }
          activeKcals = activeKcalStats
          
          group2.leave()
        }
        
        group2.notify(queue: .main) {
          let representableWorkout = RepresentableWorkout(id: workout.uuid.uuidString,
                                                          start: workout.startDate,
                                                          end: workout.endDate,
                                                          duration: workout.duration,
                                                          distance: distance,
                                                          activityType: workout.workoutActivityType,
                                                          heartRateValues: heartRateStats,
                                                          activeKcals: activeKcals)
          
          representableWorkouts.append(representableWorkout)
          group.leave()
        }
      }
    }
    
    for workout in workouts {
      self.getKcal(for: workout) { _ in
        print("got kcal\n\n")
      }
    }
    group.notify(queue: .main) {
      // This closure will be called when all async operations are complete
      completion(representableWorkouts)
    }
  }
  
  
  // MARK: - GET HEART RATE
  private func getHeartRate(for workout: HKWorkout, completion: @escaping ([Double]?) -> ()) {
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
  
  
  // MARK: - GET ACTIVE KCAL
  private func getKcal(for workout: HKWorkout,  completion: @escaping ([Double]?) -> ()) {
    guard let store else {
      completion(nil)
      return
    }
    var activeKcals = [Double]()
    
    let start      = workout.startDate
    let end        = workout.endDate
    let anchor     = Date.firstDayOfWeek()
    let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
    
    let query = HKStatisticsCollectionQuery(quantityType: activeEnergyBurnedType,
                                            quantitySamplePredicate: predicate,
                                            anchorDate: anchor,
                                            intervalComponents: DateComponents(minute: 1))
    
    query.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: start, to: end) { stats, _ in
        guard let oneMinuteStat = stats.sumQuantity() else { return }
        
        // Calculate the active calories burned for each minute and add it to the array.
        let doubleStat = oneMinuteStat.doubleValue(for: .largeCalorie())
        activeKcals.append(doubleStat)
      }
      completion(activeKcals)
    }
    
    // Execute the HealthKit query.
    store.execute(query)
  }
  
  
  // MARK: - GET HKWORKOUTS
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
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                          ascending: true)
    let query = HKSampleQuery(
      sampleType: workoutType,
      predicate: compoundPredicate,
      limit: 0,
      sortDescriptors: [sortDescriptor]) { (query, sample, error) in
        
        // Handle the query results.
        guard let sample = sample as? [HKWorkout],
              error == nil  else {
          completion(nil, error)
          return
        }
        completion(sample, nil)
      }
    
    // Execute the HealthKit query.
    store.execute(query)
  }
}
