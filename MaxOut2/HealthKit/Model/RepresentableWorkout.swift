import Foundation
import HealthKit

struct RepresentableWorkout: Identifiable, Equatable, Hashable {
  let id             : String
  let start          : Date
  let end            : Date
  let duration       : TimeInterval
  let distance       : Double
  let activityType   : HKWorkoutActivityType
  let heartRateValues: [Double]
  let activeKcals    : [Double]
  
  public var minHeartRateValue: Double? {
    heartRateValues.min()
  }
  public var maxHeartRateValue: Double? {
    heartRateValues.max()
  }
  public var avgHeartRateValue: Double? {
    guard !heartRateValues.isEmpty else { return nil }
    let sum = heartRateValues.reduce(0, +)
    return sum / Double(heartRateValues.count)
  }
  
  public var activeEnergyBurned: Double? {
    guard !activeKcals.isEmpty else { return nil }
    let sum = activeKcals.reduce(0, +)
    return sum
  }
  
  public var minutes: String {
    String(format: "%.0f", (duration / 60))
  }
  
  public var km: String? {
    guard distance != 0 else { return nil }
    return String(format: "%.2f", (distance / 1000))
  }
}

extension RepresentableWorkout {
  static let previewData = RepresentableWorkout(id: "4815162342", start: Date().tenMinutesAgo(), end: Date(), duration: 600, distance: 1234, activityType: .rowing, heartRateValues: [0,1,2,3,4], activeKcals: [5,6,7,8,8,9,])
}

extension Date {
  func tenMinutesAgo() -> Date {
    return Calendar.current.date(byAdding: .minute, value: -10, to: self) ?? self
  }
}
  
