import Foundation
import HealthKit

struct Activity: Identifiable, Hashable {
  var id: String { type.name }
  var name: String { type.name }
  var type: HKWorkoutActivityType
  var image: String { type.sfSymbol }
  let workouts: [HKWorkout]
  
  var duration: TimeInterval {
    var duration = 0.0
    for workout in workouts {
      duration += workout.duration
    }
    return duration
  }
  
  var durationString: (hour: String, minute: String) { duration.durationString() }
  
  static let allActivities: [HKWorkoutActivityType] = [
      .elliptical,
      .rowing,
      .running,
      .traditionalStrengthTraining,
      .walking,
      .yoga,
      .coreTraining,
      .flexibility,
      .highIntensityIntervalTraining,
      .jumpRope,
      .pilates,
      .stairs,
      .stepTraining,
      .wheelchairRunPace,
      .taiChi,
      .mixedCardio,
      .handCycling,
      .fitnessGaming
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
