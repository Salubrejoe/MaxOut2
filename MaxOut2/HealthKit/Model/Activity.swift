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
  
  var durationString: String {
    let totalDuration = Int(duration)
    let hours = totalDuration / 3600
    let minutes = (totalDuration % 3600) / 60
    
    let hourString = hours > 0 ? "\(hours)h" : ""
    let minuteString = minutes > 0 ? "\(minutes)m" : ""
    
    return "\(hourString) \(minuteString)".trimmingCharacters(in: .whitespaces)
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
