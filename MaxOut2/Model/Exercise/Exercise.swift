
import Foundation

struct ExercisesArray: Codable {
  let exercises: [Exercise]
}

struct Exercise: Identifiable, Equatable {
  let id             : String
  var name           : String
  
  var category       : String
  var primaryMuscles : [String]
  var instructions   : [String]
  var equipment      : String?
  
  var dateModified   = Date()
  var isSelected     = false
}


// MARK: - CODABLE
extension Exercise: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.primaryMuscles, forKey: .primaryMuscles)
    try container.encode(self.instructions, forKey: .instructions)
    try container.encode(self.category, forKey: .category)
    try container.encodeIfPresent(self.equipment, forKey: .equipment)
    try container.encode(self.dateModified, forKey: .dateModified)
    try container.encode(self.isSelected, forKey: .isSelected)
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case primaryMuscles
    case instructions
    case category
    case equipment
    case dateModified
    case isSelected
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.primaryMuscles = try container.decode([String].self, forKey: .primaryMuscles)
    self.instructions = try container.decode([String].self, forKey: .instructions)
    self.category = try container.decode(String.self, forKey: .category)
    self.equipment = try container.decodeIfPresent(String.self, forKey: .equipment)
  }
}
