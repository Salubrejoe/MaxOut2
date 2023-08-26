import Foundation


// MARK: - Extension Date
extension Date {
  
  /// HKManager
  func minusDays(_ number: Int) -> Date {
    Calendar.current.date(byAdding: .day, value: -number, to: self) ?? self
  }


  
  static func firstDayOfWeek() -> Date {
    let calendar =  Calendar(identifier: .iso8601)
    let components: Set<Calendar.Component> = [.yearForWeekOfYear, .weekOfYear]
    return calendar.date(from: calendar.dateComponents(components, from: Date())) ?? Date()
  }
  
  static func yesterday() -> Date {
    let calendar = Calendar.current
    let today = Date()
    
    // Define the date components for one day ago (yesterday)
    var dateComponents = DateComponents()
    dateComponents.weekOfYear = -4
    
    // Calculate yesterday's date using the calendar
    if let yesterday = calendar.date(byAdding: dateComponents, to: today) {
      return yesterday
    } else {
      // If there's an issue calculating the date, return today's date as a fallback
      return today
    }
  }
}
