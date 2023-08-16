

import Foundation

struct Routine: Codable, Identifiable, Hashable {
  
  let id            : String
  var title         : String
  var sessionsPaths : [SessionPath]
  var dateEnded     : Date?
  var dateStarted   : Date
  var duration      : TimeInterval
  let activityType  : String
  
  init(
    sessionsPaths : [SessionPath] = [],
    dateEnded     : Date? = nil,
    dateStarted   : Date = Date(),
    duration      : TimeInterval = 0,
    activityType  : String
  ) {
    
    var title: String {
      let calendar = Calendar.current
      let currentHour = calendar.component(.hour, from: Date())
      
      if (4..<8).contains(currentHour) {
        return "Early Morning Workout"
      } else if (8..<11).contains(currentHour) {
        return "Morning Workout"
      } else if (11..<13).contains(currentHour) {
        return "Midday Workout"
      } else if (13..<17).contains(currentHour) {
        return "Afternoon Workout"
      } else if (17..<22).contains(currentHour) {
        return "Evening Workout"
      } else {
        return "Night Workout"
      }
    }
    
    self.id            = UUID().uuidString
    self.title         = title
    self.sessionsPaths = sessionsPaths
    self.dateEnded     = dateEnded
    self.dateStarted   = dateStarted
    self.duration      = duration
    self.activityType  = activityType
  }
}

struct SessionPath: Codable, Hashable {
  let exerciseId : String
  let sessionId  : String
}
