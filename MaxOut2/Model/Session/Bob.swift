import Foundation

struct Bob: Hashable {
  var kg          : Double
  var reps        : Double
  var duration    : TimeInterval
  var distance    : Double
  var isCompleted : Bool
  
  
  init(
    kg          : Double = 0,
    reps        : Double = 0,
    duration    : TimeInterval = 0,
    distance    : Double = 0,
    isCompleted : Bool = false
  ) {
    self.kg          = kg
    self.reps        = reps
    self.duration    = duration
    self.distance    = distance
    self.isCompleted = isCompleted
  }
  
  init(bob: Bob) {
    self.kg          = bob.kg
    self.reps        = bob.reps
    self.duration    = bob.duration
    self.distance    = bob.distance
    self.isCompleted = false
  }
}

// MARK: - CODABLE
extension Bob: Codable {
  enum CodingKeys: String, CodingKey {
    case kg
    case reps
    case duration
    case distance
    case isCompleted
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.kg, forKey: .kg)
    try container.encode(self.reps, forKey: .reps)
    try container.encode(self.duration, forKey: .duration)
    try container.encode(self.distance, forKey: .distance)
    try container.encode(self.isCompleted, forKey: .isCompleted)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.kg = try container.decode(Double.self, forKey: .kg)
    self.reps = try container.decode(Double.self, forKey: .reps)
    self.duration = try container.decode(TimeInterval.self, forKey: .duration)
    self.distance = try container.decode(Double.self, forKey: .distance)
    self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
  }
}
