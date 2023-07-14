import Foundation


struct Bob: Hashable, Identifiable {
  var id: String
  
  var kg          : String
  var reps        : String
  var distance    : String
  var duration    : TimeInterval
  var isCompleted : Bool
  var restTime    : Double = 50.0
  
  init(
    kg          : String = "0",
    reps        : String = "0",
    duration    : TimeInterval = 0,
    distance    : String = "0",
    isCompleted : Bool = false,
    restTime    : Double = 50.0
  ) {
    self.id          = UUID().uuidString
    self.kg          = kg
    self.reps        = reps
    self.duration    = duration
    self.distance    = distance
    self.isCompleted = isCompleted
    self.restTime    = restTime
  }
  
  init(bob: Bob) {
    self.id          = UUID().uuidString
    self.kg          = bob.kg
    self.reps        = bob.reps
    self.duration    = bob.duration
    self.distance    = bob.distance
    self.isCompleted = false
    self.restTime    = 50.0
  }
}

// MARK: - CODABLE
extension Bob: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case kg
    case reps
    case duration
    case distance
    case isCompleted
    case restTime
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.kg, forKey: .kg)
    try container.encode(self.reps, forKey: .reps)
    try container.encode(self.duration, forKey: .duration)
    try container.encode(self.distance, forKey: .distance)
    try container.encode(self.isCompleted, forKey: .isCompleted)
    try container.encode(self.restTime, forKey: .restTime)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.kg = try container.decode(String.self, forKey: .kg)
    self.reps = try container.decode(String.self, forKey: .reps)
    self.duration = try container.decode(TimeInterval.self, forKey: .duration)
    self.distance = try container.decode(String.self, forKey: .distance)
    self.restTime = try container.decode(Double.self, forKey: .restTime)
    self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
  }
}
