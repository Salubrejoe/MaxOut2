import SwiftUI
import Charts



// MARK: - TIME RANGE for HKQuery

enum TimeRange: String, CaseIterable, Identifiable {
  case W  = "W"
  case TW = "2W"
  case M  = "M"
  case SM = "6M"
  case Y  = "Y"
  var id: TimeRange { self }
  
  var startDate : Date {
    switch self {
      case .W :
        let calendar = Calendar.current
        return calendar.date(byAdding: .day,
                                      value: -6,
                                      to: Date()) ?? Date()
      case .TW :
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear,
                                      value: -2,
                                      to: Date()) ?? Date()
      case .M :
        let calendar = Calendar.current
        return calendar.date(byAdding: .month,
                                      value: -1,
                                      to: Date()) ?? Date()
      case .SM :
        let calendar = Calendar.current
        return calendar.date(byAdding: .month,
                                      value: -6,
                                      to: Date()) ?? Date()
      case .Y :
        let calendar = Calendar.current
        return calendar.date(byAdding: .month,
                                      value: -12,
                                      to: Date()) ?? Date()
    }
  }
  
  var resolution: Int {
    switch self {
      case .W:
        return 1
      case .TW:
        return 1
      case .M:
        return 1
      case .SM:
        return 7
      case .Y:
        return 30
    }
  }
  
  var barWidth: MarkDimension {
    switch self {
      case .W  : return MarkDimension(integerLiteral: 27)
      case .TW : return MarkDimension(integerLiteral: 17)
      case .M  : return MarkDimension(integerLiteral: 7)
      case .SM : return MarkDimension(integerLiteral: 7)
      case .Y  : return MarkDimension(integerLiteral: 17)
    }
  }
  
  var barOffset: Double {
    switch self {
      case .W  : return -27
      case .TW : return -17/2
      case .M  : return -7
      case .SM : return -7/2
      case .Y  : return -17/2
    }
  }
  
  var numberOfDays: Int {
    switch self {
      case .W  : return 7
      case .TW : return 14
      case .M  : return 30
      case .SM : return 180
      case .Y  : return 365
    }
  }
  
  var stringForWidget: String {
    switch self {
      case .W  : return "last 7 days"
      case .TW : return "last 2 weeks"
      case .M  : return "last month"
      case .SM : return "last 6 months"
      case .Y  : return "last year"
    }
  }
}
