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
    .chartYAxis {
      AxisMarks(values: [0, manager.maxExerciseTime])
      AxisMarks(values: [50]) { value in
        AxisGridLine(centered: true, stroke: StrokeStyle(dash: [2]))
          .foregroundStyle(Color.exerciseRing)
        AxisValueLabel() {
          Text("50").foregroundColor(.exerciseRing)
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


