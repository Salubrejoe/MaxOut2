import Foundation
import HealthKit

struct Activity: Identifiable, Equatable, Hashable {
  let type: HKWorkoutActivityType
  
  var id: String { name }
  var name: String { type.commonName }
  var isFavorite: Bool = false
  var workouts: [RepresentableWorkout]?
  
  public var duration: TimeInterval {
    guard let workouts else { return 0 }
    var duration = 0.0
    for workout in workouts {
      duration += workout.duration
    }
    return duration
  }
  
  public var durationString: (hour: String, minute: String) { duration.durationString() }
  
//  public var representableWorkouts: [RepresentableWorkout]? {
//    guard let workouts else { return nil }
//    
//    var representableWorkouts = [RepresentableWorkout]()
//    for workout in workouts {
//      
//      let start = workout.startDate
//      let end = workout.endDate
//      let duration = workout.duration
//      var activeCalories = 0.0
//      if let activeEnergyBurned = workout.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity() {
//        activeCalories = activeEnergyBurned.doubleValue(for: .largeCalorie())
//      }
//      
//      
//      let representableWorkout = RepresentableWorkout(id: UUID().uuidString,
//                                                      start: start,
//                                                      end: end,
//                                                      duration: duration,
//                                                      activeCalories: activeCalories)
//      representableWorkouts.append(representableWorkout)
//    }
//    return representableWorkouts
//  }
}

struct RepresentableWorkout: Identifiable, Equatable, Hashable {
  let id             : String
  let start          : Date
  let end            : Date
  let duration       : TimeInterval
//  let activeCalories : Double
  let heartRateValues: [Double]
}

