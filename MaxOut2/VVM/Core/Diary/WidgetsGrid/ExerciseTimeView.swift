
import SwiftUI

struct ExerciseQuery {
  let resolution: Int
  let startDate: Date
}

struct ExerciseTimeView: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    NavigationStack {
      ScrollView {
        
        Picker("", selection: $manager.timeRange) {
          ForEach(TimeRange.allCases) { range in
            Text(range.rawValue)
          }
        }
        .pickerStyle(.segmented)
        .padding([.horizontal, .bottom])
        .onChange(of: manager.timeRange) { newValue in
          manager.getExerciseTime(newValue.query)
          manager.resolution = Double(newValue.query.resolution)
          manager.startDate = newValue.query.startDate
        }
        
        HStack {
          VStack(alignment: .leading, spacing: -2) {
            Text(average())
              .font(.caption)
              .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
              Text(averageMinutes())
                .font(.largeTitle)
              Text("min")
                .font(.title2)
                .foregroundColor(.secondary)
            }
            Text(formatDateRange())
              .font(.caption)
              .foregroundColor(.secondary)
          }
          Spacer()
        }
        .padding(.horizontal, 22)
        
        ExerciseMinutesWidget()
          .padding([.leading, .horizontal, .bottom])
          .frame(height: 200)
      }
      .dismissButton()
      .navigationTitle("Edit Card").navigationBarTitleDisplayMode(.inline)
    }
  }
  
  private func formatDateRange() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    
    let startDateMonth = Calendar.current.dateComponents([.month], from: manager.startDate)
    let startDateDay = Calendar.current.dateComponents([.day], from: manager.startDate)
    let startDay = startDateDay.day ?? 0
    let currentMonth = Calendar.current.dateComponents([.month], from: Date())
    
    let todayString = dateFormatter.string(from: Date())
    
    guard currentMonth != startDateMonth else {
      return "\(startDay)-\(todayString) \(Date().yearAsString())"
    }
    
    let startDateString = dateFormatter.string(from:manager.startDate)
    
    if startDateString == todayString {
      return "\(startDateString), \(Date().yearAsString())"
    }
    else {
      return "\(startDateString)-\(todayString) \(Date().yearAsString())"
    }
  }
  
  private func average() -> String {
    switch manager.resolution {
      case 1 : return "DAILY AVERAGE"
      case 7 : return "WEEKLY AVERAGE"
      case 30 : return "MONTHLY AVERAGE"
      default : return "AVERAGE BOBOBOBO"
    }
  }
  
  private func averageMinutes() -> String {
    var duration = 0.0
    var count = 0.0
    for stat in manager.exerTimeStats {
      let statMin = stat.minutes
      if statMin != 0 {
        duration += statMin
        count += 1
      }
    }
    let drt = duration/manager.resolution
    let avg = drt/count
    return String(format: "%.0f", avg)
  }
  
//  private func dataPointAvg() -> String? {
//    var duration = 0.0
//    var conto = 0
//    guard !manager.exerTimeStats.isEmpty else { return nil }
//    for exerciseTimeStat in manager.exerTimeStats {
//      duration += exerciseTimeStat.minutes
//      if exerciseTimeStat.minutes != 0.0 {
//        print("Minutes: \(exerciseTimeStat.minutes)")
//        conto += 1
//        print("Conto: \(conto)")
//      }
//    }
//
//    let count = conto - 1
//    let average = duration/Double(conto)
//    let realAverage = average/Double(manager.resolution)
//
//    print("Duration: \(duration)")
//    print("Average: \(average)")
//    print("Conto: \(conto)")
//    print("Count: \(count)")
//    print("ExCount: \(manager.exerTimeStats.count)")
//    print("Resol: \(manager.resolution) \n")
//    return String(format: "%.0f", realAverage)
//  }
}

struct ExerciseTimeView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseTimeView()
  }
}


extension Date {
  func yearAsString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: self)
  }
}


