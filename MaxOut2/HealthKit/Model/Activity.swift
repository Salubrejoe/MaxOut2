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
}
