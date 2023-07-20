import Foundation
import HealthKit

struct HealthStat: Identifiable {
  let id = UUID()
  
  let stat: HKQuantity?
  let date: Date
  
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
}
