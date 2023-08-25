import Foundation
import HealthKit

struct HealthStatQuantity: Identifiable, Equatable, Hashable {
  let id = UUID()
  
  let stat: HKQuantity?
  let date: Date
  
  var kcal: Double? {
    stat?.doubleValue(for: .largeCalorie())
  }
  var hours: Double? {
    stat?.doubleValue(for: .count())
  }
  var minutes: Double? {
    stat?.doubleValue(for: .minute())
  }
  var weight: Double? {
    stat?.doubleValue(for: .gram())
  }
  var height: Double? {
    stat?.doubleValue(for: .meter())
  }
  var bpm: Double? {
    stat?.doubleValue(for: .count())
  }

  var weightString: String {
    guard let weight else { return ""}
    return String(format: "%.1f", weight)
  }
  
  var heightString: String {
    guard let height else { return ""}
    return String(format: "%.2f", height)
  }
  
  func valueToAverage(unit: HKUnit) -> Double {
    switch unit {
      case .count()        : return self.hours   ?? 0
      case .minute()       : return self.minutes ?? 0
      case .largeCalorie() : return self.kcal    ?? 0
      default : return -1
    }
  }
}
