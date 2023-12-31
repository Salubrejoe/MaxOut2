import SwiftUI
import HealthKit

enum Muscle: String, CaseIterable, Hashable {
  /// Shoulders
  case shoulders
  case traps
  case neck
  /// Arms
  case biceps
  case triceps
  case forearms
  /// Chest
  case chest
  /// Abs
  case abdominals
  /// Back
  case lowerBack = "lower back"
  case middleBack = "middle back"
  case lats
  /// Butt
  case glutes
  /// Thighs
  case hamstrings
  case abductors
  case adductors
  case quadriceps
  /// Calves
  case calves
  
  public var displayName: String {
    switch self {
      case .abdominals : return "Abs"
      default : return self.rawValue.capitalized
    }
  }
  
  var muscleGroup : MuscleGroup {
    switch self {
      case .neck, .traps, .shoulders                        : return .shoulders
      case .triceps, .biceps, .forearms                     : return .arms
      case .chest                                           : return .chest
      case .abdominals                                      : return .abs
      case .lowerBack, .middleBack, .lats                   : return .back
      case .glutes                                          : return .glutes
      case .hamstrings, .abductors, .adductors, .quadriceps : return .thighs
      case .calves                                          : return .calves
    }
  }
  
  var muscleGroupImage : String {
    switch muscleGroup {
      case .shoulders : return "shoulder"
      case .arms      : return "arm"
      case .chest     : return "front"
      case .abs       : return "front"
      case .back      : return "back"
      case .glutes    : return "glutes"
      case .thighs    : return "leg"
      case .calves    : return "leg"
    }
  }
  
  var color: Color {
    switch muscleGroup {
      case .shoulders : return Color("shoulder")
      case .arms      : return Color("arm")
      case .chest     : return Color("front")
      case .abs       : return Color("abs")
      case .back      : return Color("back")
      case .glutes    : return Color("glutes")
      case .thighs    : return Color("leg")
      case .calves    : return Color("leg")
    }
  }
}

enum MuscleGroup: String, CaseIterable, Codable {
  case shoulders = "shoulders"
  case arms = "arms"
  case chest = "chest"
  case abs = "abs"
  case back = "back"
  case glutes = "glutes"
  case thighs = "thighs"
  case calves = "calves"
}

enum EquipmentType: String, CaseIterable, Hashable {
  case body         = "body only"
  case machine      = "machine"
  case kettlebells  = "kettlebell"
  case dumbbell     = "dumbbell"
  case cable        = "cable"
  case barbell      = "barbell"
  case bands        = "bands"
  case medicineBall = "medicine ball"
  case exerciseBall = "exercise ball"
  case ezCurlBar    = "e-z bar"
  case foamRoll     = "foam roller"
  case treadmill    = "treadmill"
  case other        = "plate"
  
  public var image : String {
    switch self {
      case .body        : return ""
      case .machine     : return "machine"
      case .kettlebells : return "kettlebell"
      case .dumbbell    : return "dumbbell"
      case .cable       : return "cable"
      case .barbell     : return "barbell"
      case .bands       : return "bands"
      case .medicineBall: return "medicineball"
      case .exerciseBall: return "exerciseball"
      case .ezCurlBar   : return "ezbar"
      case .foamRoll    : return "foamroller"
      case .treadmill   : return "treadmill"
      case .other       : return "plate"
    }
  }
}

enum CategoryType: String, CaseIterable, Hashable {
  case strength             = "strength"
  case stretching           = "stretching"
  case plyometrics          = "plyometrics"
  case strongman            = "strongman"
  case powerlifting         = "powerlifting"
  case cardio               = "cardio"
  case olympicWeightlifting = "olympic weightlifting"
}




enum ActivityType: String, CaseIterable, Hashable, Codable {
  case coreTraining                  = "core training"
  case elliptical                    = "elliptical"
  case flexibility                   = "flexibility"
  case highIntensityIntervalTraining = "high intensity interval training"
  case jumpRope                      = "jump rope"
  case mixedCardio                   = "mixed cardio"
  case rowing                        = "rowing" 
  case running                       = "running"
  case skatingSports                 = "skating"
  case stairs                        = "stairs"
  case traditionalStrengthTraining   = "strength training"
  case walking                       = "walking"
  case tableTennis                   = "table tennis"

  var hkType: HKWorkoutActivityType {
    switch self {
      case .elliptical:
        return .elliptical
      case .rowing:
        return .rowing
      case .running:
        return .running
      case .traditionalStrengthTraining:
        return .traditionalStrengthTraining
      case .walking:
        return .walking
      case .coreTraining:
        return .coreTraining
      case .flexibility:
        return .flexibility
      case .highIntensityIntervalTraining:
        return .highIntensityIntervalTraining
      case .jumpRope:
        return .jumpRope
      case .stairs:
        return .stairs
      case .skatingSports:
        return .skatingSports
      case .tableTennis:
        return .tableTennis
      case .mixedCardio:
        return .mixedCardio
    }
  }
  
  static let types: [HKWorkoutActivityType] = [
    .elliptical,
    .rowing,
    .running,
    .traditionalStrengthTraining,
    .walking,
    .coreTraining,
    .mixedCardio,
    .flexibility,
    .highIntensityIntervalTraining,
    .jumpRope,
    .stairs,
    .skatingSports,
    .tableTennis
  ]
}
