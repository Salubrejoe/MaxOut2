import Foundation

/// Needs Equatable to get firstIndex(of:)
struct Session: Identifiable, Equatable {
  
  var id           : String
  let exerciseId   : String
  let exerciseName : String
  var dateCreated  : Date
  let category     : String
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
    category     : String,
    bobs         : [Bob],
    image        : String
  ) {
    self.id           = id
    self.exerciseId   = exerciseId
    self.exerciseName = exerciseName
    self.dateCreated  = dateCreated
    self.category     = category     
    self.bobs         = bobs
    self.image        = image
  }
  
  func calculateBestBob(for session: Session) throws -> (bob: Bob, index: Int) {
    guard !session.bobs.isEmpty else {
      throw URLError(.badServerResponse)
    }
    
    var maxResult = Double.leastNormalMagnitude // Initialize with the smallest possible value
    var bestBobIndex = 0
    
    for (index, bob) in session.bobs.enumerated() {
      let result = bob.kg * Double(bob.reps)
      //  + bob.distance * bob.duration
      // TODO: FIX CALCULATIONS
      
      if result > maxResult {
        maxResult = result
        bestBobIndex = index
      }
    }
    
    let bestBob = session.bobs[bestBobIndex]
    
    return (bestBob, bestBobIndex)
  }
  
  func markBobsAsComplete(session: inout Session) {
    for index in 0..<session.bobs.count {
      session.bobs[index].isCompleted = true
    }
  }
  
}

extension Session: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case exerciseId
    case exerciseName
    case dateCreated
    case category
    case bobs
    case image
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.exerciseId, forKey: .exerciseId)
    try container.encode(self.exerciseName, forKey: .exerciseName)
    try container.encode(self.dateCreated, forKey: .dateCreated)
    try container.encode(self.category, forKey: .category)
    try container.encode(self.bobs, forKey: .bobs)
    try container.encode(self.image, forKey: .image)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.exerciseId = try container.decode(String.self, forKey: .exerciseId)
    self.exerciseName = try container.decode(String.self, forKey: .exerciseName)
    self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    self.category = try container.decode(String.self, forKey: .category)
    self.bobs = try container.decode([Bob].self, forKey: .bobs)
    self.image = try container.decode(String.self, forKey: .image)
  }
}



