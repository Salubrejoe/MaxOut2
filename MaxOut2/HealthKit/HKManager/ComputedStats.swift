import HealthKit
import Foundation


// MARK: - ACTIVITIES
extension HealthKitManager {
  public func workouts(for activityType: HKWorkoutActivityType) -> [RepresentableWorkout]? {
    self.representableWorkouts?.filter { $0.activityType == activityType }
  }
  public var currentActivities: [Activity] {
    var acts = [Activity]()
    for type in HKWorkoutActivityType.allCases {
      if let workouts = self.workouts(for: type), !workouts.isEmpty {
        let activity = Activity(type: type, workouts: workouts)
        acts.append(activity)
      }
    }
    return acts
  }
}


// MARK: - RING GOALS
extension HealthKitManager {
  public var exerTimeGoalDouble: Double {
    guard let exerciseTimeGoal else { return 0 }
    if let stat = exerciseTimeGoal.stat {
      return stat.doubleValue(for: .minute())
    }
    return 0
  }
  
  public var exerTimeGoalString: String {
    String(format: "%0.f", exerTimeGoalDouble)
  }
  
  public var activeEnergyBurnedGoalDouble: Double {
    guard let activeEnergyBurnedGoal else { return 0 }
    if let stat = activeEnergyBurnedGoal.stat {
      return stat.doubleValue(for: .largeCalorie())
    }
    return 0
  }
  
  public var activeEnergyBurnedGoalString: String {
    String(format: "%0.f", activeEnergyBurnedGoalDouble)
  }
  
  public var standTimeGoalDouble: Double {
    guard let standHoursGoal else { return 0 }
    if let stat = standHoursGoal.stat {
      return stat.doubleValue(for: .count())
    }
    return 0
  }
  
  public var standTimeGoalString: String {
    String(format: "%0.f", standTimeGoalDouble)
  }
}


// MARK: - HEIGHT AND WEIGHT
extension HealthKitManager {
  public var heightProfileString: String {
    guard let heightStats,
          let something = heightStats.last else { return "" }
    return "📏\(something.heightString) meters tall"
  }
  
  public var heightString: String {
    guard let heightStats,
          let something = heightStats.last else { return "" }
    return "\(something.heightString) m"
  }
  
  public var maxWeight: Double {
    guard let bodyMassStats else { return 0 }
    var weights: [Double] = []
    for stat in bodyMassStats {
      weights.append(stat.weight ?? 0)
    }
    return weights.max() ?? 0
  }
  
  public var minWeight: Double {
    guard let bodyMassStats else { return 0 }
    var weights: [Double] = []
    for stat in bodyMassStats {
      weights.append(stat.weight ?? 0)
    }
    return weights.min() ?? 0
  }
}
