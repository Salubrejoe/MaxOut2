import Foundation
import HealthKit

enum tsActivityType: String {
  case elliptical = "elliptical"
  case rowing = "rowing"
  case running = "running"
  case traditionalStrengthTraining = "weight lifting"
  case walking = "walking"
  case coreTraining = ""
  case flexibility = "flexibility"
  case highIntensityIntervalTraining = "high intensity interval training"
  case jumpRope = "jump rope"
  case skatingSports = "skating"
  case wheelchairRunPace = "wheelchair run pace"
}

struct NewActivity: Identifiable, Equatable {
  var id: String
  var name: String
  var exercises: [Exercise]
  
  var equipments: [String] {
    var array = [String]()
    for exercise in exercises {
      if let equipment = exercise.equipment,
         !array.contains(equipment) {
        array.append(equipment)
      }
    }
    return array
  }
  
  var groupedExercises: [(String, [Exercise])] {
    let sortedItems = exercises.sorted { $0.name < $1.name }
    let grouped = Dictionary(grouping: sortedItems) { String($0.name.prefix(1)) }
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  var alphabet: [String] {
    var a: [String] = []
    for groupedExercise in groupedExercises {
      a.append(groupedExercise.0)
    }
    return a
  }
  
  public var logo: String {
    switch name {
      case "weight lifting" : return "figure.strengthtraining.traditional"
      case "core training" : return "figure.core.training"
      case "high intensity interval training" : return "figure.highintensity.intervaltraining"
      case "flexibility" : return "figure.cooldown"
      case "elliptical" : return "figure.elliptical"
      case "jump rope" : return "figure.jumprope"
      case "rowing" : return "figure.rower"
      case "running" : return "figure.run"
      case "skating" : return "figure.skating"
      case "walking" : return "figure.walk"
      default: return ""
    }
  }
}

struct Activity: Identifiable, Hashable {
  var id: String { type.name }
  var name: String { type.name }
  var type: HKWorkoutActivityType
  var image: String { type.sfSymbol }
  var workouts: [HKWorkout]
  var exercises: [Exercise]? = nil
  
  var duration: TimeInterval {
    var duration = 0.0
    for workout in workouts {
      duration += workout.duration
    }
    return duration
  }
  
  var durationString: (hour: String, minute: String) { duration.durationString() }
  
  static let tsActivities: [HKWorkoutActivityType] = [
      .elliptical,
      .rowing,
      .running,
      .traditionalStrengthTraining,
      .walking,
      .coreTraining,
      .flexibility,
      .highIntensityIntervalTraining,
      .jumpRope,
      .stairs,
      .skatingSports,
      .wheelchairRunPace,
    ]
}

extension TimeInterval {
  func durationString() -> (hour: String, minute: String) {
    let totalDuration = Int(self)
    let hours = totalDuration / 3600
    let minutes = (totalDuration % 3600) / 60
    var minutesString = ""
    if minutes == 0 { minutesString = "00" }
    else if minutes < 10 { minutesString = "0\(String(format: "%.0f", Double(minutes)))"}
    else { minutesString = String(format: "%.0f", Double(minutes)) }
    let hourString = hours > 0 ? "\(hours)" : ""
    
    return (hourString, minutesString)
  }
}
