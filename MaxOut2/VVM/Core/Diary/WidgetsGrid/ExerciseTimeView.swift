
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
          manager.resolution = newValue.query.resolution
        }
        
        HStack {
          VStack(alignment: .leading, spacing: -2) {
            Text("AVERAGE")
              .font(.caption)
              .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
              Text("34")
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
        
        GroupBox {
          ExerciseMinutesWidget()
            .padding(.leading)
        }
        .frame(height: 300)
        .groupBoxStyle(RegularMaterialStyle())
        .padding(.horizontal)
        .padding(.bottom)
        
        
//          VStack {
//            HStack {
//              Text("Start Date").font(.headline)
//              Spacer()
//              DatePicker("", selection: $manager.startDate, in: ...Date(), displayedComponents: .date)
//                .onChange(of: manager.startDate) { newValue in
//                  manager.getExerciseTime()
//                }
//            }
//            Divider()
//            HStack {
//              Text("Average every ").font(.headline)
//              Spacer()
//              HStack(spacing: 0) {
//                Picker("days", selection: $manager.resolution) {
//                  ForEach(1..<manager.intervalInDays, id: \.self) {
//                    Text("\($0)")
//                  }
//                }
//                .onChange(of: manager.resolution) { newValue in
//                  manager.getExerciseTime()
//                }
//                Text(manager.resolution == 1 ? "day" : "days")
//              }
//            }
//          }
//        .padding(.horizontal)
      }
      .navigationTitle("Exercise Time").navigationBarTitleDisplayMode(.inline)
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
