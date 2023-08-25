import SwiftUI
import HealthKit
import Charts

struct ActivitiesList: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    if let activities = manager.currentActivities {
      
      List(activities) { activity in
        
        if let workouts = activity.workouts {
          Section(activity.name) {
            
            ForEach(workouts) { workout in
                VStack(alignment: .leading) {
                  Text("Duration: \(workout.duration.formatElapsedTime())")
                  Text("Start: \(workout.start.formatted())")
                  Text("End: \(workout.end.formatted())")
                  ScrollView(.horizontal) {
                    HStack {
                      if workout.heartRateValues.count > 2 {
                        ForEach(1..<workout.heartRateValues.count, id: \.self) { index in
                          Rectangle()
                            .frame(width: 2, height: workout.heartRateValues[index])
                        }
                      }
                    }
                  }
                  .frame(height: 200)
                  
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
