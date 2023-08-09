import Foundation

/// Needs Equatable to get firstIndex(of:)
struct Session: Identifiable, Equatable {
  
  var id           : String
  let exerciseId   : String
  let exerciseName : String
  var dateCreated  : Date
  let activityType : ActivityType
  var bobs         : [Bob]
  let image        : String
  
  var timeString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let date = dateCreated
    return dateFormatter.string(from: date)
  }
  
  init(
    id           : String,
    exerciseId   : String,
    exerciseName : String,
    dateCreated  : Date,
    activityType : ActivityType,
    bobs         : [Bob],
    image        : String
  ) {
    self.id           = id
    self.exerciseId   = exerciseId
    self.exerciseName = exerciseName
    self.dateCreated  = dateCreated
    self.activityType = activityType
    self.bobs         = bobs
    self.image        = image
  }
}


// MARK: - CODABLE
extension Session: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case exerciseId
    case exerciseName
    case dateCreated
    case activityType
    case bobs
    case image
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.exerciseId, forKey: .exerciseId)
    try container.encode(self.exerciseName, forKey: .exerciseName)
    try container.encode(self.dateCreated, forKey: .dateCreated)
    try container.encode(self.activityType, forKey: .activityType)
    try container.encode(self.bobs, forKey: .bobs)
    try container.encode(self.image, forKey: .image)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.exerciseId = try container.decode(String.self, forKey: .exerciseId)
    self.exerciseName = try container.decode(String.self, forKey: .exerciseName)
    self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    self.activityType = try container.decode(ActivityType.self, forKey: .activityType)
    self.bobs = try container.decode([Bob].self, forKey: .bobs)
    self.image = try container.decode(String.self, forKey: .image)
  }
}



