import SwiftUI
import HealthKit
import Charts

struct ActivitiesList: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    if !manager.currentActivities.isEmpty {
      
      let activities = manager.currentActivities

      List(activities) { activity in

        if let workouts = activity.workouts {

          Section(activity.name) {

            ForEach(workouts) { workout in

                VStack(alignment: .leading) {

                  Text("Duration: \(workout.duration.formatElapsedTime())")

                  Text("Start: \(workout.start.formatted())")
                  Text("End: \(workout.end.formatted())")

                  if let avgHR = workout.avgHeartRateValue {
                    Text("Average bpm: \(String(format: "%.0f", avgHR))")
                  }

                  if let maxHR = workout.maxHeartRateValue {
                    Text("Max bpm: \(String(format: "%.0f", maxHR))")
                  }

                  if let minHR = workout.minHeartRateValue {
                    Text("Min bpm: \(String(format: "%.0f", minHR))")
                  }
                  
                  if let kcal = workout.activeEnergyBurned {
                    Text("Kcal: \(String(format: "%.0f", kcal))")
                  }
                  else {
                    Text("No data")
                  }
                } 
              }
          }
        }
      }
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    ActivitiesList().environmentObject(HealthKitManager())
  }
}
