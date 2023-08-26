import Foundation
import HealthKit

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
