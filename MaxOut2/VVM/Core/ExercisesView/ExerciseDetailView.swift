import SwiftUI

struct ExerciseDetailViiu: View {
  @Environment(\.dismiss) var dismiss
  enum CoordinateSpases {
    case scrollView
  }
  @Binding var exercise: Exercise
  @State private var editedExercise: Exercise
  
  init(exercise: Binding<Exercise>) {
    self._exercise = exercise
    self._editedExercise = State(wrappedValue: exercise.wrappedValue)
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      TextField("Name", text: $editedExercise.name)
        .font(.largeTitle)
        .padding()

      
      privatePicker()
      
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
    }
    .navigationTitle("Edit")
    .navigationBarTitleDisplayMode(.inline)
    .onDisappear {
      exercise = editedExercise
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
    ExerciseDetailViiu(exercise: .constant(Exercise.mockup))
  }
}
