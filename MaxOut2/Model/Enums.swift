import Foundation

enum Muscle: String, CaseIterable {
  case noSelection = ""
  /// Shoulders
  case shoulders = "shoulders"
  case traps     = "traps"
  case neck      = "neck"
  /// Arms
  case biceps   = "biceps"
  case triceps  = "triceps"
  case forearms = "forearms"
  /// Chest
  case chest = "chest"
  /// Abs
  case abdominals = "abdominals"
  /// Back
  case lowerBack  = "lower back"
  case middleBack = "middle back"
  case lats       = "lats"
  /// Butt
  case glutes = "glutes"
  /// Thighs
  case hamstrings = "hamstrings"
  case abductors  = "abductors"
  case adductors  = "adductors"
  case quadriceps = "quadriceps"
  /// Calves
  case calves = "calves"
  
  var image: String {
    switch self {
      case .noSelection : return ""
      case .neck, .traps, .shoulders                        : return "shoulders"
      case .triceps, .biceps, .forearms                     : return "arms"
      case .chest                                           : return "chest"
      case .abdominals                                      : return "abs"
      case .lowerBack, .middleBack, .lats                   : return "back"
      case .glutes                                          : return "glutes"
      case .hamstrings, .abductors, .adductors, .quadriceps : return "thighs"
      case .calves                                          : return "calves"
    }
  }
  
  var muscleGroup : String {
    switch self {
      case .neck, .traps, .shoulders                        : return "shoulders"
      case .triceps, .biceps, .forearms                     : return "arms"
      case .chest                                           : return "chest"
      case .abdominals                                      : return "abs"
      case .lowerBack, .middleBack, .lats                   : return "back"
      case .glutes                                          : return "glutes"
      case .hamstrings, .abductors, .adductors, .quadriceps : return "thighs"
      case .calves                                          : return "calves"
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
}

enum Equipment: String, CaseIterable {
  case noSelection  = ""
  case body         = "bodyonly"
  case machine      = "machine"
  case kettlebells  = "kettlebell"
  case dumbbell     = "dumbbell"
  case cable        = "cable"
  case barbell      = "barbell"
  case bands        = "bands"
  case medicineBall = "medicineball"
  case exerciseBall = "exerciseball"
  case ezCurlBar    = "ezbar"
  case foamRoll     = "foamroller"
  case other        = "plate"
}

enum Category: String, CaseIterable {
  case noSelection          = ""
  case strength             = "strength" // 💪
  case stretching           = "stretching" // 🙆🏽
  case plyometrics          = "plyometrics" // 🤼‍♀️
  case strongman            = "strongman" // 🦾
  case powerlifting         = "powerlifting" // 🤷🏻
  case cardio               = "cardio" // 🏃🏿
  case olympicWeightlifting = "olympic weightlifting" // 🏋🏾
  
  var image: String {
    switch self {
      case .strength:
        return "dumbbell"
      case  .olympicWeightlifting, .powerlifting:
        return "figure.strengthtraining.traditional"
      case .strongman:
        return "figure.cross.training"
      case .stretching:
        return "figure.cooldown"
      case .cardio:
        return "bolt.heart.fill"
      case .plyometrics:
        return "figure.kickboxing"
      case .noSelection:
        return ""
    }
  }
}

enum Force: String, CaseIterable {
  case pull = "pull"
  case push = "push"
  case stat = "static"
}

enum Level: String, CaseIterable {
  case beginner     = "beginner"
  case intermediate = "intermediate"
  case expert       = "expert"
}

enum Mechanic: String, CaseIterable {
  case compound  = "compound"
  case isolation = "isolation"
}
