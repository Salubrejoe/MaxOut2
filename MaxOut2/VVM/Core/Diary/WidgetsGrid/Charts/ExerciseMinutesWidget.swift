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
      .offset(x: switchOffset)
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
    .padding(.leading)
    .transition(.scale)
    .animation(.spring(), value: manager.exerTimeStats)
  }
  
  private var switchWidth: MarkDimension {
    switch manager.timeRange {
      case .W  : return MarkDimension(integerLiteral: 27)
      case .TW  : return MarkDimension(integerLiteral: 22)
      case .M  : return MarkDimension(integerLiteral: 7)
      case .SM : return MarkDimension(integerLiteral: 7)
      case .Y  : return MarkDimension(integerLiteral: 17)
    }
  }
  
  private var switchOffset: Double {
    switch manager.timeRange {
      case .W  : return -27
      case .TW  : return -22
      case .M  : return -7
      case .SM : return -7/2
      case .Y  : return -17/2
    }
  }
}

struct ExerciseMinutesWidget_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseMinutesWidget().environmentObject(HealthKitManager())
  }
}


