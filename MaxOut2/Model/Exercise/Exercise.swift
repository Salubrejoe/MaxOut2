
import SwiftUI

struct ExercisesArray: Codable {
  let exercises: [Exercise]
}

struct Exercise: Identifiable, Equatable, Hashable {
  static let mockup = Exercise(id: "",
                               name: "New Exercise",
                               category: "cardio",
                               activity: "high intensity interval training",
                               primaryMuscles: ["chest"],
                               instructions: [""],
                               equipment: "barbell",
                               dateModified: Date(),
                               isSelected: false)
  var id             : String
  var name           : String
  
  var category       : String
  var activity       : String
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
    try container.encode(self.activity, forKey: .activity)
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
    case activity
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
    self.activity = try container.decode(String.self, forKey: .activity)
    self.equipment = try container.decodeIfPresent(String.self, forKey: .equipment)
  }
}

// MARK: - FORZATURE dovute al MODEL
extension Exercise {
  
  var equipmentImage: String {
    switch equipment {
      case "noSelection"   :   return "plate"
      case "body only"     :   return ""
      case "machine"       :   return "machine"
      case "kettlebells"   :   return "kettlebell"
      case "dumbbell"      :   return "dumbbell"
      case "cable"         :   return "cable"
      case "barbell"       :   return "barbell"
      case "bands"         :   return "bands"
      case "medicine ball" :   return "medicineball"
      case "exercise ball" :   return "exerciseball"
      case "e-z curl bar"  :   return "ezbar"
      case "foam roll"     :   return "foamroller"
      case "other"         :   return "plate"
      default: return "plate"
        
    }
  }
  
  var muscleGroup : String {
    switch primaryMuscles[0] {
      case "" : return "glutes"
      case "neck", "traps", "shoulders"                         : return "shoulders"
      case "triceps", "biceps", "forearms"                      : return "arms"
      case "chest"                                              : return "chest"
      case "abdominals"                                         : return "abs"
      case "lower back", "middle back", "lats"                  : return "back"
      case "glutes"                                             : return "glutes"
      case "hamstrings", "abductors", "adductors", "quadriceps" : return "thighs"
      case "calves"                                             : return "calves"
      default : return ""
    }
  }
  
  var muscleGroupImage : String {
    switch muscleGroup {
      case "shoulders" : return "shoulder"
      case "arms"      : return "arm"
      case "chest"     : return "front"
      case "abs"       : return "front"
      case "back"      : return "back"
      case "glutes"    : return "glutes"
      case "thighs"    : return "leg"
      case "calves"    : return "leg"
      default: return ""
    }
  }
  
  var color: Color {
    switch muscleGroup {
      case "shoulders": return Color("shoulder")
      case "arms"     : return Color("arm")
      case "chest"    : return Color("front")
      case "abs"      : return Color("abs")
      case "back"     : return Color("back")
      case "glutes"   : return Color("glutes")
      case "thighs"   : return Color("leg")
      case "calves"   : return Color("leg")
      default: return .black
    }
  }
}
