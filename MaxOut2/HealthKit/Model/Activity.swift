import Foundation
import HealthKit

struct Activity: Identifiable, Equatable, Hashable {
  var id: String { type.name }
  var name: String
  var exercises: [Exercise]?
  var workouts: [HKWorkout]?
  
  public var type: HKWorkoutActivityType {
    switch name {
      case "elliptical" : return .elliptical
      case "rowing" : return .rowing
      case "running" : return .running
      case "weight lifting" : return .traditionalStrengthTraining
      case "walking" : return .walking
      case "core training" : return .coreTraining
      case "flexibility" : return .flexibility
      case "high intensity interval training" : return .highIntensityIntervalTraining
      case "jump rope" : return .jumpRope
      case "skating" : return .skatingSports
      case "wheelchair run pace" : return .wheelchairRunPace
      default : return .running
    }
  }
  
  public var groupedExercises: [(String, [Exercise])] {
    guard let exercises else { return [] }
    let sortedItems = exercises.sorted { $0.name < $1.name }
    let grouped = Dictionary(grouping: sortedItems) { String($0.name.prefix(1)) }
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  public var alphabet: [String] {
    var a: [String] = []
    for groupedExercise in groupedExercises {
      a.append(groupedExercise.0)
    }
    return a
  }
  
  public var logo: String {
    return type.sfSymbol
  }
  
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



