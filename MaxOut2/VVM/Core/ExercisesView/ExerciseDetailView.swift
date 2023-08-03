import SwiftUI

struct ExerciseDetailViiu: View {
  @Environment(\.dismiss) var dismiss
  enum CoordinateSpases {
    case scrollView
  }
  @Binding var exercise: Exercise
  @Binding var tabBarIsHidden: Bool
  @State private var editedExercise: Exercise
  
  init(exercise: Binding<Exercise>, tabBarIsHidden: Binding<Bool>) {
    self._exercise = exercise
    self._editedExercise = State(wrappedValue: exercise.wrappedValue)
    self._tabBarIsHidden = tabBarIsHidden
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      TextField("Name", text: $editedExercise.name)
        .font(.largeTitle)
        .fontWeight(.semibold)
        .padding()

      
      HStack {
        Text(exercise.equipmentString)
          .frame(maxWidth: .infinity)
        Divider()
          .padding(.vertical, 2)
        Text(exercise.muscleString)
          .frame(maxWidth: .infinity)
        Divider()
          .padding(.vertical, 2)
        Text(exercise.activityType.rawValue.capitalized)
          .frame(maxWidth: .infinity)
      }
      .fontWeight(.heavy)
      
      TabView {
        ForEach($editedExercise.instructions.indices, id: \.self) { index in
          GroupBox {
            TextEditor(text: $editedExercise.instructions[index])
              .scrollContentBackground(.hidden)
          } label: {
            HStack {
              Text("INSTRUCTIONS")
              Spacer()
              Image(systemName: "\(index + 1).circle")
            }
            .foregroundColor(.secondary)
          }
        }
      }
      .tabViewStyle(.page)
      .frame(height: 250)
    }
    .padding(.horizontal)
    .textFieldClearButton
    .onAppear {
      UIPageControl.appearance().currentPageIndicatorTintColor = .label
      UIPageControl.appearance().pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
      tabBarIsHidden = true
    }
    .navigationTitle("Edit")
    .navigationBarTitleDisplayMode(.inline)
    .onDisappear {
      exercise = editedExercise
      tabBarIsHidden = false
    }
  }
  
  @ViewBuilder
  private func privatePicker() -> some View {
    Picker("", selection: $editedExercise.category) {
      let activityTypes : [ActivityType] = ActivityType.allCases
      ForEach(activityTypes, id: \.self) {
        Text($0.rawValue.capitalized)
      }
    }
  }
}





struct ExerciseDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseDetailViiu(exercise: .constant(Exercise.mockup), tabBarIsHidden: .constant(true))
  }
}
