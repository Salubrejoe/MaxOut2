import SwiftUI
import Charts



struct ChartGrid: View {
  @EnvironmentObject var model: DiaryViewModel
  
  var body: some View {
    if let userStats = model.userStats {
      
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 155))]) {
          ForEach(userStats) { stat in
            GroupBox {
              VStack {
                Text(stat.exerciseName)
                  .fontWeight(.semibold)
                  .frame(maxWidth: .infinity, alignment: .leading)
                ExerciseChart(dataPoints: dataPoints(for: stat)) 
              }
            }
            .groupBoxStyle(RegularMaterialStyle())
          }
        }
      
    }
  }
  
  func dataPoints(for stat: UserStat) -> [DataPoint] {
    let activityType = ActivityType(rawValue: stat.activityType) ?? .jumpRope
    switch activityType {
      case .coreTraining, .highIntensityIntervalTraining, .traditionalStrengthTraining :
        return stat.totalVolumeDP
      case .elliptical, .rowing, .running, .walking, .mixedCardio, .skatingSports:
        return stat.speedDP
      default :
        return stat.durationDP
    }
  }
}

struct ExerciseChart: View {
  let dataPoints: [DataPoint]
  
  var body: some View {
    
        Chart(dataPoints) { dataPoint in
          BarMark(
            x: .value("Week Day", dataPoint.x),
            y: .value("Mass", dataPoint.y)
          )
        }
      
    }
  }

