
import SwiftUI



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
        .onChange(of: manager.timeRange) { _ in
          manager.getStats()
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
    
    let startDateMonth = Calendar.current.dateComponents([.month], from: manager.timeRange.startDate)
    let startDateDay = Calendar.current.dateComponents([.day], from: manager.timeRange.startDate)
    let startDay = startDateDay.day ?? 0
    let currentMonth = Calendar.current.dateComponents([.month], from: Date())
    
    let todayString = dateFormatter.string(from: Date())
    
    guard currentMonth != startDateMonth else {
      return "\(startDay)-\(todayString) \(Date().yearAsString())"
    }
    
    let startDateString = dateFormatter.string(from: manager.timeRange.startDate)
    
    if startDateString == todayString {
      return "\(startDateString), \(Date().yearAsString())"
    }
    else {
      return "\(startDateString)-\(todayString) \(Date().yearAsString())"
    }
  }
  
  private func average() -> String {
    switch manager.timeRange.resolution {
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
    let drt = duration/Double(manager.timeRange.resolution)
    let avg = drt/count
    return String(format: "%.0f", avg)
  }
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


