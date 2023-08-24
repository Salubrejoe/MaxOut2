import Foundation
import HealthKit

struct Activity: Identifiable, Equatable, Hashable {
  var id: String { name }
  var name: String { type.commonName }
  var type: HKWorkoutActivityType
  var workouts: [HKWorkout]?
  
  var isFavorite: Bool = false
  
  public var duration: TimeInterval {
    guard let workouts else { return 0 }
    var duration = 0.0
    for workout in workouts {
      duration += workout.duration
    }
    return duration
  }
  
  public var durationString: (hour: String, minute: String) { duration.durationString() }
}



