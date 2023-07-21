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
  
  var durationString: (hour: String, minute: String) {
    let totalDuration = Int(duration)
    let hours = totalDuration / 3600
    let minutes = (totalDuration % 3600) / 60
    let minutesString = minuteString(for: Double(minutes))
    let hourString = hours > 0 ? "\(hours)" : ""
    
    return (hourString, minutesString)
  }
  
  private func minuteString(for minute: Double) -> String {
    if minute == 0 { return "00" }
    else if minute < 10 { return "0\(String(format: "%.0f", minute)))"}
    else { return String(format: "%.0f", minute) }
  }
  
  static let allActivities: [HKWorkoutActivityType] =
    [
      .elliptical,
      .rowing,
      .running,
      .stairClimbing,
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
      .wheelchairWalkPace,
      .wheelchairRunPace,
      .taiChi,
      .mixedCardio,
      .handCycling,
      .fitnessGaming
    ]
  
}
