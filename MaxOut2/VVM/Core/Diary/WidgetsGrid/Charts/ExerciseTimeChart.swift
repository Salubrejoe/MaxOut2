import SwiftUI
import Charts

struct ExerciseMinutesWidget: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    Chart(manager.exerTimeStats) { stat in
      BarMark(
        x: .value("Week Day", stat.date),
        y: .value("Min", stat.minutes/Double(manager.resolution)),
        width: switchWidth
      )
      .foregroundStyle(Color.exerciseRing.gradient)
      .cornerRadius(4)
      
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
    .transition(.opacity)
    .animation(.spring(), value: manager.timeRange)
  }
  
  private var switchWidth: MarkDimension {
    switch manager.timeRange {
      case .W  : return MarkDimension(integerLiteral: 27)
      case .M  : return MarkDimension(integerLiteral: 7)
      case .SM : return MarkDimension(integerLiteral: 7)
      case .Y  : return MarkDimension(integerLiteral: 17)
    }
  }
}

struct ExerciseMinutesWidget_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseMinutesWidget().environmentObject(HealthKitManager())
  }
}


