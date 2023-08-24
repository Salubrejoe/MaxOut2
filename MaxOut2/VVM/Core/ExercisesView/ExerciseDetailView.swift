import SwiftUI
import MarqueeText

struct ExerciseDetailViiu: View {
  @Environment(\.dismiss) var dismiss
  enum CoordinateSpases {
    case scrollView
  }
  @Binding var exercise: Exercise
  @Binding var tabBarState: BarState
  @State private var editedExercise: Exercise
  
  init(exercise: Binding<Exercise>, tabBarState: Binding<BarState>) {
    self._exercise = exercise
    self._editedExercise = State(wrappedValue: exercise.wrappedValue)
    self._tabBarState = tabBarState
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
//      TextField("Name", text: $editedExercise.name)
//        .font(.largeTitle)
//        .fontWeight(.semibold)
//        .padding()
      
      VStack(alignment: .leading) {
        MarqueeText(text: editedExercise.name, font: .preferredFont(forTextStyle: .largeTitle), leftFade: 5, rightFade: 0, startDelay: 2)
          .fontWeight(.semibold)
        
        HStack {
          //        Text(exercise.equipmentString)
          MarqueeText(text: editedExercise.equipmentString, font: .preferredFont(forTextStyle: .headline), leftFade: 5, rightFade: 0, startDelay: 2)
            .frame(maxWidth: .infinity)
          Divider()
          //        Text(exercise.muscleString)
          MarqueeText(text: editedExercise.muscleString, font: .preferredFont(forTextStyle: .headline), leftFade: 5, rightFade: 0, startDelay: 2)
            .frame(maxWidth: .infinity)
          Divider()
          //        Text(exercise.activityType.rawValue.capitalized)
          MarqueeText(text: editedExercise.activityType.hkType.name.capitalized, font: .preferredFont(forTextStyle: .headline), leftFade: 5, rightFade: 0, startDelay: 2)
            .frame(maxWidth: .infinity)
        }
        .padding(. vertical)
      }
      
      
      TabView {
        ForEach($editedExercise.instructions.indices, id: \.self) { index in
          GroupBox {
            TextEditor(text: $editedExercise.instructions[index])
              .scrollContentBackground(.hidden)
              .padding(.bottom)
          } label: {
            HStack {
              Text("HOW TO")
              Spacer()
              Image(systemName: "\(index + 1).circle")
            }
            .foregroundColor(.secondary)
          }
        }
      }
      .tabViewStyle(.page)
      .frame(height: 300)
    }
    .padding(.horizontal)
    .textFieldClearButton
    .onAppear {
      UIPageControl.appearance().currentPageIndicatorTintColor = .label
      UIPageControl.appearance().pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
      tabBarState = .hidden
    }
    .onDisappear {
      exercise = editedExercise
      tabBarState = .large
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
    ExerciseDetailViiu(exercise: .constant(Exercise.mockup), tabBarState: .constant(.large))
  }
}
