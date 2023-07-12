import Foundation

// MARK: - EXTENSION TIME INTERVAL

extension TimeInterval {
  func formatElapsedTime() -> String {
    let minutes = Int(self) / 60
    let seconds = Int(self) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}


extension Double {
  func asTimeString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
/*
 10000.asString(style: .positional)  // 2:46:40
 10000.asString(style: .abbreviated) // 2h 46m 40s
 10000.asString(style: .short)       // 2 hr, 46 min, 40 sec
 10000.asString(style: .full)        // 2 hours, 46 minutes, 40 seconds
 10000.asString(style: .spellOut)    // two hours, forty-six minutes, forty seconds
 10000.asString(style: .brief)       // 2hr 46min 40sec
 */
