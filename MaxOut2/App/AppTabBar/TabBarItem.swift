import SwiftUI
import Combine

struct TabBarItemo: Hashable {
  let iconName: String
  let title: String
  let color: Color
}


enum TabBarItem: Hashable {
  case diary, start, exercises
  
  var iconName: String {
    switch self {
      case .diary : return "book.closed"
      case .start : return "bolt.ring.closed"
      case .exercises : return "figure.hiking"
    }
  }
  
  var title: String {
    switch self {
      case .diary : return "Diary"
      case .start : return "Start"
      case .exercises : return "Exercises"
    }
  }
  
  var color: Color {
    switch self {
      case .diary : return .red
      case .start : return .purple
      case .exercises : return .blue
    }
  }
}
