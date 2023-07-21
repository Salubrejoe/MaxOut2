import SwiftUI
import Charts

struct ExerciseMinutesWidget: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    Chart(manager.exerTimeStats) { stat in
      BarMark(
        x: .value("Week Day", stat.date),
        y: .value("Min", stat.minutes/2)
      )
      .foregroundStyle(Color.exerciseRing.gradient)
      .cornerRadius(10)
      .offset(x: -3)
    }
    .chartYAxisLabel("min", position: .topTrailing)
    .chartYAxis {
      AxisMarks(values: [0, manager.maxExerciseTime])
      AxisMarks(values: [manager.exerTimeGoalDouble]) { value in
        AxisGridLine(centered: true, stroke: StrokeStyle(dash: [2]))
          .foregroundStyle(Color.exerciseRing)
        AxisValueLabel() {
          if let _ = manager.exerTimeGoal {
            VStack(alignment: .leading) {
              Text("Goal")
              Text(manager.exerTimeGoalString)
            }
            .foregroundColor(.exerciseRing)
          }
        }
      }
    }
  }
}

struct ExerciseMinutesWidget_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseMinutesWidget().environmentObject(HealthKitManager())
  }
}


