import SwiftUI
import Charts

struct BodyMassChart: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    Chart(manager.bodyMassStats) { stat in
      LineMark(
        x: .value("Week Day", stat.date),
        y: .value("Kg", stat.weight)
      )
      .interpolationMethod(.catmullRom)
      .foregroundStyle(Color.purple.gradient)
      .symbol(Circle())
    }
    .chartYScale(domain: [manager.minWeight, manager.maxWeight])
    .chartYAxisLabel("kg", position: .topTrailing)
    .onAppear {
      manager.getBodyMassStats()
    }
  }
}

struct BodyMassChart_Previews: PreviewProvider {
  static var previews: some View {
    BodyMassChart().environmentObject(HealthKitManager())
  }
}
