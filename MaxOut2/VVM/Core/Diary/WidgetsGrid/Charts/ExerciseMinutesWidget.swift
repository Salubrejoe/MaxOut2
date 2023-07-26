import SwiftUI
import Charts

struct ExerciseMinutesWidget: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    Chart(manager.exerTimeStats) { stat in
      BarMark(
        x: .value("Week Day", stat.date),
        y: .value("Min", stat.minutes/Double(manager.timeRange.resolution)),
        width: manager.timeRange.barWidth
      )
      .foregroundStyle(Color.exerciseRing.gradient)
      .cornerRadius(4)
      .offset(x: manager.timeRange.barOffset)
    }
    
    .chartYAxisLabel("min", position: .topTrailing)
    .chartYAxis {
      AxisMarks(values: [0, manager.maxExerciseTime])
      
      // GOAL Y MARK
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
    .padding(.leading)
    .transition(.scale)
    .animation(.spring(), value: manager.exerTimeStats)
  }
}

struct ExerciseMinutesWidget_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseMinutesWidget().environmentObject(HealthKitManager())
  }
}


