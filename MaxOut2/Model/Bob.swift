import Foundation


struct Bob: Hashable, Identifiable {
  var id: String
  
  var mass        : Double
  var reps        : Double
  var distance    : String
  var duration    : [Int]
  var isCompleted : Bool
  var restTime    : Double = 50.0
  
  init(
    kg          : Double = 0,
    reps        : Double = 0,
    duration    : [Int]  = [],
    distance    : String = "0",
    isCompleted : Bool    = false,
    restTime    : Double  = 50.0
  ) {
    self.id          = UUID().uuidString
    self.mass        = kg
    self.reps        = reps
    self.duration    = duration
    self.distance    = distance
    self.isCompleted = isCompleted
    self.restTime    = restTime
  }
  
  init(bob: Bob) {
    self.id          = UUID().uuidString
    self.mass        = bob.mass
    self.reps        = bob.reps
    self.duration    = bob.duration
    self.distance    = bob.distance
    self.isCompleted = false
    self.restTime    = 50.0
  }
}

// MARK: - USABLE PROPERTIES
extension Bob {
  
  public var kg: Measurement<UnitMass> {
    Measurement(value: mass, unit: UnitMass.kilograms)
  }
  
  public var pounds: Measurement<UnitMass> {
    kg.converted(to: UnitMass.pounds)
  }
  
  public var km: Measurement<UnitLength> {
    let km = Double(distance) ?? 0
    return Measurement(value: km, unit: UnitLength.kilometers)
  }
  
  public var miles: Measurement<UnitLength> {
    km.converted(to: UnitLength.miles)
  }
}


// MARK: - COMPUTED PROPERTIES
extension Bob {
  
  public var kgVolume: Int {
    Int(kg.value*reps)
  }
  
  public var lbsVolume: Int {
    Int(pounds.value*reps)
  }
  
  
  
  public var timeInterval: Int {
    guard duration.count == 3 else { return 0 }
    var timeInterval = 0
    timeInterval += duration[2]
    timeInterval += duration[1] * 60
    timeInterval += duration[0] * 3600
    return timeInterval
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
    try container.encode(self.mass, forKey: .kg)
    try container.encode(self.reps, forKey: .reps)
    try container.encode(self.duration, forKey: .duration)
    try container.encode(self.distance, forKey: .distance)
    try container.encode(self.isCompleted, forKey: .isCompleted)
    try container.encode(self.restTime, forKey: .restTime)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.mass = try container.decode(Double.self, forKey: .kg)
    self.reps = try container.decode(Double.self, forKey: .reps)
    self.duration = try container.decode([Int].self, forKey: .duration)
    self.distance = try container.decode(String.self, forKey: .distance)
    self.restTime = try container.decode(Double.self, forKey: .restTime)
    self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
  }
}
