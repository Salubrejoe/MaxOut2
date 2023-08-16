import Foundation
import HealthKit

struct Activity: Identifiable, Equatable, Hashable {
  var id: String { hkType.name }
  var name: ActivityType
  var exercises: [Exercise]?
  var workouts: [HKWorkout]?
  
  public var hkType: HKWorkoutActivityType {
    switch name {
      case .elliptical:
        return .elliptical
      case .rowing:
        return .rowing
      case .running:
        return .running
      case .traditionalStrengthTraining:
        return .traditionalStrengthTraining
      case .walking:
        return .walking
      case .coreTraining:
        return .coreTraining
      case .flexibility:
        return .flexibility
      case .highIntensityIntervalTraining:
        return .highIntensityIntervalTraining
      case .jumpRope:
        return .jumpRope
      case .skatingSports:
        return .skatingSports
      case .stairs:
        return .stairs
      case .tableTennis:
        return .tableTennis
      case .mixedCardio:
        return .mixedCardio
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



