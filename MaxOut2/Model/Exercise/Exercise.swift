
import SwiftUI

struct ExercisesArray: Codable {
  let exercises: [Exercise]
}

struct Exercise: Identifiable, Equatable, Hashable {
  static let mockup = Exercise(id: "",
                               name: "New Exercise",
                               category: "cardio",
                               primaryMuscles: ["chest"],
                               instructions: [
                                "Begin by standing on one leg, with the bent knee raised. This will be your start position.",
                                "Using a countermovement jump, take off upward by extending the hip, knee, and ankle of the grounded leg.",
                                "Immediately flex the knee and attempt to touch your butt with the heel of your jumping leg.",
                                "Return the leg to a partially bent position underneath the hips and land. Your opposite leg should stay in relatively the same position throughout the drill."
                               ],
                               equipment: "barbell",
                               dateModified: Date(),
                               isSelected: false)
  var id             : String
  var name           : String
  var category       : String
  var primaryMuscles : [String]
  var instructions   : [String]
  var equipment      : String?
  var dateModified   = Date()
  var isSelected     = false
}


// MARK: - COMPUTED PROPERTIES
extension Exercise {
  public var categoryType : CategoryType {
    CategoryType(rawValue: category) ?? .cardio
  }
  
  public var activityType : ActivityType {
    switch categoryType {
      case .strength:
        return strenghtSieved()
      case .stretching:
        return .flexibility
      case .plyometrics:
        return .highIntensityIntervalTraining
      case .strongman:
        return .highIntensityIntervalTraining
      case .powerlifting:
        return .highIntensityIntervalTraining
      case .cardio:
        return cardioSieve()
      case .olympicWeightlifting:
        return .traditionalStrengthTraining
    }
  }
  
  public var muscle : Muscle {
    if let firstMuscle = primaryMuscles.first {
      return Muscle(rawValue: firstMuscle) ?? .forearms
    }
    else {
      return .shoulders
    }
  }
  
  public var muscleString : String {
    muscle.rawValue.capitalized
  }
  
  public var equipmentType : EquipmentType {
    if let equipment {
      return EquipmentType(rawValue: equipment) ?? .body
    }
    else {
      return .body
    }
  }
  
  public var equipmentString : String {
    guard equipmentType != .body else { return "" }
    return equipmentType.rawValue.capitalized
  }
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
    self.equipment = try container.decodeIfPresent(String.self, forKey: .equipment)
    self.category = try container.decode(String.self, forKey: .category)
  }
}

// TO CALCULATE ACTIVITY
extension Exercise {
  
  private func strenghtSieved() -> ActivityType {
    switch muscle.muscleGroup {
      case .abs : return .coreTraining
      default: return .traditionalStrengthTraining
    }
  }
  
  private func cardioSieve() -> ActivityType {
    switch name {
      case "Elliptical Trainer" : return .elliptical
      case "Rope Jumping" : return .jumpRope
      case "Rowing Machine" : return .rowing
      case "Running" : return .running
      case "Skating" : return .skatingSports
      case "Walking" : return .walking
      default : return .mixedCardio
    }
  }
}
