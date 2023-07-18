import Foundation
import HealthKit

struct HealthStat: Identifiable {
  let id = UUID()
  
  let stat: HKQuantity?
  let date: Date
}
