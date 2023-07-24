
import SwiftUI

struct ExerciseTimeView: View {
  @EnvironmentObject var manager: HealthKitManager
  
  @State private var days = 0.0
  @State private var weeks = 0.0
  @State private var months = 0.0
  @State private var years = 0.0
  
  @State private var number: Int = 0
  @State private var string = "W"
  
  @State private var startDate = Date()
  
  var body: some View {
    NavigationStack {
      ScrollView {
        
        HStack {
          VStack(alignment: .leading, spacing: -2) {
            Text("AVERAGE")
              .font(.caption)
              .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 0) {
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
          HStack(alignment: .center, spacing: 0) {
            Text("Start Date").font(.headline)
            Spacer()
            DatePicker("", selection: $startDate, displayedComponents: .date)
          }
        }
        .groupBoxStyle(RegularMaterialStyle())
        .padding(.horizontal)
      }
      .navigationTitle("Exercise Time").navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct ExerciseTimeView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseTimeView()
  }
}
