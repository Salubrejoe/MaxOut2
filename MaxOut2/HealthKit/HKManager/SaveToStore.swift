import HealthKit
import Foundation

extension HealthKitManager {
  
  func saveWorkout(start: Date,
                   end: Date,
                   activityType: ActivityType) {
    guard let store, HKHealthStore.isHealthDataAvailable() else {
      print("HealthKit is not available on this device.")
      return
    }
    
    let startInt = start.timeIntervalSince1970
    let endInt = end.timeIntervalSince1970
    let duration = endInt - startInt
    
    let workout = HKWorkout(activityType: activityType.hkType,
                            start: start,
                            end: end,
                            duration: duration,
                            totalEnergyBurned: nil,
                            totalDistance: nil,
                            metadata: nil)
    
    store.save(workout) { (success, error) -> Void in
      guard success else {
        print("Mistakes in HK - saveWorkouts()")
        return
      }
    }
  }
  
  func submit(weight: Double) {
    guard let store else { return }
    
    let quantityType = HKQuantityType(.bodyMass)
    
    let quantity = HKQuantity.init(unit: HKUnit.gramUnit(with: .kilo),
                                   doubleValue: weight)
    
    let bodyMass = HKQuantitySample(type: quantityType,
                                    quantity: quantity,
                                    start: Date(),
                                    end: Date())
    store.save(bodyMass) { success, error in
      guard error == nil else {
        print("Error saving weight: \n \(error?.localizedDescription))")
        return
      }
      
      if success { print("Saved! 😄 \(success)")}
    }
    getWeightStats()
  }
  
  func submit(height: Double) {
    guard let store else { return }
    
    let quantityType = HKQuantityType(.height)
    
    let quantity = HKQuantity.init(unit: HKUnit.meter(),
                                   doubleValue: height)
    
    
    let bodyMass = HKQuantitySample(type: quantityType,
                                    quantity: quantity,
                                    start: Date(),
                                    end: Date())
    store.save(bodyMass) { success, error in
      guard error == nil else {
        print("Error saving height: \n \(error?.localizedDescription))")
        return
      }
      
      if success { print("Saved Height! 😄 \(success)")}
    }
    
    getHeightStats()
  }
}
