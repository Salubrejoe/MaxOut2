
import SwiftUI
import MarqueeText


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
        
        RingWidget(ring: .exercise)
          .padding([.leading, .horizontal, .bottom])
          .frame(height: 200)
        
        if let acts = manager.currentActivities {
          LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]) {
            ForEach(acts) { activity in
              ActivityCell(activity: activity, text: manager.timeRange.stringForWidget) {
                //              manager.toggleFavorite(activity)
              }
            }
          }
        }
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
    for stat in manager.exerciseTimeStats {
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


struct ActivityCell: View {
  let activity: Activity
  let text: String
  
  let heartTapped: () -> ()
  
  var body: some View {
    HStack {
      Image(systemName: activity.type.sfSymbol)
        .imageScale(.large)
        .foregroundStyle(Color.exerciseRing.gradient)
        .frame(width: 40)
      
      MarqueeText(text: activity.name.capitalized, font: UIFont.preferredFont(forTextStyle: .headline), leftFade: 5, rightFade: 5, startDelay: 4)
        .frame(maxWidth: .infinity)
      
      HhMmView(hour: activity.durationString.hour, minute: activity.durationString.minute)
      Button {
        heartTapped()
      } label: {
        Image(systemName: activity.isFavorite ? "heart.fill" : "heart")
          .foregroundColor(activity.isFavorite ? .pink : .secondary)
      }
    }
    .padding()
    .background(Color.systemBackground)
    .cornerRadius(10)
  }
}


extension Date {
  func yearAsString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: self)
  }
}


