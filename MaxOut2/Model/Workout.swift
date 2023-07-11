
import Foundation

struct Workout: Identifiable, Codable, Equatable {
  static func == (lhs: Workout, rhs: Workout) -> Bool {
    lhs.id == rhs.id
  }
  
  var id: String { routine.id }
  let routine: Routine
  let sessions: [Session]
  
  var monthYear: Int {
    let date = routine.dateStarted
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let result = (year * 100) + month
    return result
  }
  
  var year: String {
    let date = routine.dateStarted
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    return "\(year)"
  }
  
  var month: String {
    let date = routine.dateStarted
    let calendar = Calendar.current
    let month = calendar.component(.month, from: date)
    let monthSymbols = calendar.monthSymbols
    return "\(monthSymbols[month - 1])"
  }
}
