import Foundation
import HealthKit

struct HealthStatQuantity: Identifiable, Equatable, Hashable {
  let id  = UUID()
  let stat: HKQuantity?
  let date: Date
}

// COMPUTED PROPERTIES
extension HealthStatQuantity {
  
  public var kcal: Double? {
    stat?.doubleValue(for: .largeCalorie())
  }
  public var hours: Double? {
    stat?.doubleValue(for: .count())
  }
  public var minutes: Double? {
    stat?.doubleValue(for: .minute())
  }
  public var weight: Double? {
    stat?.doubleValue(for: .gram())
  }
  public var height: Double? {
    stat?.doubleValue(for: .meter())
  }
  public var bpm: Double? {
    stat?.doubleValue(for: .count())
  }
  public var weightString: String {
    guard let weight else { return ""}
    return String(format: "%.1f", weight)
  }
  public var heightString: String {
    guard let height else { return ""}
    return String(format: "%.2f", height)
  }
  public func valueToAverage(unit: HKUnit) -> Double {
    switch unit {
      case .count()        : return self.hours   ?? 0
      case .minute()       : return self.minutes ?? 0
      case .largeCalorie() : return self.kcal    ?? 0
      default : return -1
    }
  }
}
