import SwiftUI
import Charts


struct RingWidget: View {
  @EnvironmentObject var manager: HealthKitManager
  let ring: Ring
  
  var body: some View {
    Chart(appropriateStats()) { stat in
      BarMark(
        x: .value("", stat.date),
        y: .value(ring.measure.capitalized, appropriateValue(stat: stat)),
        width: manager.timeRange.barWidth
      )
      .foregroundStyle(appropriateColor().gradient)
      .cornerRadius(4)
      .opacity(0.6)
    }

    .chartYAxisLabel(ring.measure, position: .topTrailing)
    .chartYAxis {
      AxisMarks(values: [appropriateGoal()]) { value in
        AxisGridLine(centered: true, stroke: StrokeStyle(dash: [2]))
          .foregroundStyle(appropriateColor().gradient)
        AxisValueLabel() {
          if let _ = appropriateGoal() {
            VStack(alignment: .leading) {
              Text("Goal")
              Text(appropriateString())
            }
            .foregroundColor(appropriateColor())
          }
        }
      }
    }
    .transition(.scale)
    .animation(.spring(), value: appropriateStats())
    .padding(.horizontal)
  }

  
  private func appropriateStats() -> [HealthStatQuantity] {
    switch ring {
      case .move     : return manager.activeEnergyBurnedStats ?? []
      case .exercise : return manager.exerciseTimeStats ?? []
      case .stand    : return manager.standHoursStats ?? []
    }
  }
  
  private func appropriateGoal() -> HealthStatQuantity? {
    switch ring {
      case .move     : return manager.activeEnergyBurnedGoal
      case .exercise : return manager.exerciseTimeGoal
      case .stand    : return manager.standHoursGoal
    }
  }
  
  private func appropriateGoal() -> Double {
    switch ring {
      case .move     : return manager.activeEnergyBurnedGoalDouble
      case .exercise : return manager.exerTimeGoalDouble
      case .stand    : return manager.standTimeGoalDouble
    }
  }
  
  private func appropriateString() -> String {
    switch ring {
      case .move     : return manager.activeEnergyBurnedGoalString
      case .exercise : return manager.exerTimeGoalString
      case .stand    : return manager.standTimeGoalString
    }
  }
  
  private func appropriateValue(stat: HealthStatQuantity) -> Double {
    switch ring {
      case .move     : return stat.kcal ?? 0
      case .exercise : return stat.minutes ?? 0
      case .stand    : return stat.hours ?? 0
    }
  }
  
  private func appropriateColor() -> Color {
    switch ring {
      case .move     : return Color.moveRing
      case .exercise : return Color.exerciseRing
      case .stand    : return Color.standRing
    }
  }
}




enum Ring {
  case move, exercise, stand
  
  public var measure: String {
    switch self {
      case .move:
        return "kcal"
      case .exercise:
        return "mm"
      case .stand:
        return "hh"
    }
  }
}


