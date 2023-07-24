
import SwiftUI

struct ExerciseTimeView: View {
  @EnvironmentObject var manager: HealthKitManager
  
  @State private var days = 0.0
  @State private var weeks = 0.0
  @State private var months = 0.0
  @State private var years = 0.0
  
  @State private var number: Int = 0
  @State private var string = "W"
  
  
  var body: some View {
    NavigationStack {
      ScrollView {
        
        HStack {
          VStack(alignment: .leading, spacing: -2) {
            Text("AVERAGE")
              .font(.caption)
              .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
              Text("23")
                .font(.largeTitle)
              Text("min")
                .font(.title2)
                .foregroundColor(.secondary)
            }
            Text("15-23 Jul 2023")
              .font(.caption)
              .foregroundColor(.secondary)
          }
          Spacer()
          Button("Refresh") {
            manager.getExerciseTime()
          }
          .buttonStyle(.bordered)
        }
        .padding(.horizontal, 22)
        
        GroupBox {
          ExerciseMinutesWidget()
        }
        .frame(height: 300)
        .groupBoxStyle(RegularMaterialStyle())
        .padding(.horizontal)
        .padding(.bottom)
        
        GroupBox {
          VStack {
            HStack {
              Text("Start Date").font(.headline)
              Spacer()
              DatePicker("", selection: $manager.startDate, in: ...Date(), displayedComponents: .date)
            }
            Divider()
              .padding(.leading)
            HStack {
              Text("Average every ").font(.headline)
              Spacer()
              HStack(spacing: 0) {
                Picker("days", selection: $manager.dataPointComponents) {
                  ForEach(1..<manager.intervalInDays, id: \.self) {
                    Text("\($0)")
                  }
                }
                Text(manager.dataPointComponents == 1 ? "day" : "days")
              }
            }
          }
        }
        .groupBoxStyle(RegularMaterialStyle())
        .padding(.horizontal)
      }
      .navigationTitle("Exercise Time").navigationBarTitleDisplayMode(.inline)
    }
  }
  
  private func formatDateRange(from startDate: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    
    let startDateString = dateFormatter.string(from: startDate)
    let todayString = dateFormatter.string(from: Date())
    
    if startDateString == todayString {
      return "\(startDateString), \(Date().yearAsString())"
    } else {
      return "\(startDateString)-\(todayString) \(Date().yearAsString())"
    }
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
