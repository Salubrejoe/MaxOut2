import SwiftUI
import Charts

struct BodyMassChart: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    Chart(manager.bodyMassStats) { stat in
      LineMark(
        x: .value("Week Day", stat.date),
        y: .value("Kg", stat.weight ?? 0)
      )
      .interpolationMethod(.catmullRom)
      .foregroundStyle(Color.primary.gradient)
      .symbol(Circle())
    }
    .chartXScale()
    .chartYScale(domain: [manager.minWeight - 1, manager.maxWeight + 1])
    .chartYAxisLabel("kg", position: .topTrailing)
    .onAppear {
      manager.getWeightStats()
    }
  }
}

struct BodyMassChart_Previews: PreviewProvider {
  static var previews: some View {
    BodyMassChart().environmentObject(HealthKitManager())
  }
}
