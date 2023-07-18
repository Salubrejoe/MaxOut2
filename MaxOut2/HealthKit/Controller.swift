import Foundation
import HealthKit
import Combine

@MainActor
final class ExerciseMinutesController: ObservableObject {
  var repository: HKRepo
  
  @Published var stats = [HealthStat]()
  
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM"
    return formatter
  }()
  
  init() {
    self.repository = HKRepo()
    repository.requestHealthStat { healtStats in
      DispatchQueue.main.async {
        self.stats = healtStats
      
      }
    }
  }
  
  var measurementFormatter = MeasurementFormatter()

  func values() -> [Int] {
    stats.map { value(from: $0.stat).value }
  }

  func labels() -> [String] {
    stats.map { value(from: $0.stat).description }
  }

  func xAxisLabels() -> [String] {
    stats.map { ExerciseMinutesController.dateFormatter.string(from: $0.date) }
  }
  
  func value(from stat: HKQuantity?) -> (value: Int, description: String) {
    guard let stat else { return (0, "") }
    
    measurementFormatter.unitStyle = .long
    
   if stat.is(compatibleWith: .minute()) {
      let value = stat.doubleValue(for: .minute())
     return (Int(value), String(Int(value)))
    }
    
    return (0, "")
  }
}
