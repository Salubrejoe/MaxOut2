import Foundation
import HealthKit

struct HealthStatQuantity: Identifiable, Equatable {
  let id = UUID()
  
  let stat: HKQuantity?
  let date: Date
  
  var kcal: Double {
    let hour = stat?.doubleValue(for: .largeCalorie())
    return Double(hour ?? 0)
  }
  
  var hours: Double {
    let hour = stat?.doubleValue(for: .count())
    return Double(hour ?? 0)
  }
  
  var minutes: Double {
    let minutes = stat?.doubleValue(for: .minute())
    return Double(minutes ?? 0)
  }
  
  var weight: Double {
    let weight = stat?.doubleValue(for: .gram())
    return Double((weight ?? 0)/1000)
  }
  
  var weightString: String {
    String(format: "%.1f", weight)
  }
  
  var height: Double {
    let height = stat?.doubleValue(for: .meter())
    return Double(height ?? 0)
  }
  
  var heightString: String {
    String(format: "%.2f", height)
  }
  
  func valueToAverage(unit: HKUnit) -> Double {
    switch unit {
      case .count()        : return self.hours
      case .minute()       : return self.minutes
      case .largeCalorie() : return self.kcal
      default : return 0
    }
  }
}
