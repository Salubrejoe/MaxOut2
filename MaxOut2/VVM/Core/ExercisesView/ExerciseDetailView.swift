import SwiftUI


struct ExerciseDetailView: View {
  enum CoordinateSpases {
    case scrollView
  }
  
  @Binding var exercise: Exercise
  @ObservedObject var model : ExercisesViewModel
  
  @FocusState var focus: Bool
  
  var body: some View {
    ParallaxScrollView(background: exercise.muscle.color.opacity(0.01), coordinateSpace: CoordinateSpases.scrollView, defaultHeight: 300) {
      VStack {
        threeWayPicker
        
        TabView {
          ForEach(exercise.instructions, id: \.self) { instruction in
            Text(instruction)
              .padding()
              .frame(maxWidth: .infinity)
              .frame(height: 300)
          }
        }
        .frame(height: 200)
        .background(.ultraThinMaterial)
        .cornerRadius(7)
        .tabViewStyle(.page(indexDisplayMode: .always))
        
        buttons
      }
      .padding(.horizontal)
    } header: {
      header
    }
  }
  
  @ViewBuilder // MARK: - HEADER
  private var header: some View {
    VStack {
      TextField("Name", text: $exercise.name)
        .textFieldClearButton
        .focused($focus)
        .font(.largeTitle).bold()
        .disabled(!model.isEditing)
      BodyPartImage(exercise: exercise, color: .primary)
        .padding()
    }
    .padding(.vertical, 100)
    .padding(.horizontal, 30)
  }
  
  @ViewBuilder // MARK: - 3W PICKER
  private var threeWayPicker: some View {
    VStack {
      APicker(selectedActivityType: $model.selectedActivityType)
      Divider()
      MGPicker(selectedMuscle: $model.selectedMuscle)
      Divider()
      EQPicker(selectedEquipment: $model.selectedEquipment)
    }
    .padding(3)
    .background(.ultraThinMaterial)
    .cornerRadius(7)
    
  }
  
  @ViewBuilder // MARK: - Buttons
  private var buttons: some View {
    VStack(spacing: 7) {
      LargeTsButton(text: "Save", background: Color.accentColor, textColor: .systemBackground) {
        //
      }
      LargeTsButton(text: "Cancel", background: Color.secondarySytemBackground, textColor: Color(.darkGray)) {
        //
      }
    }
  }
}

struct ExerciseDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseDetailView(exercise: .constant(Exercise.mockup), model: ExercisesViewModel())
  }
}
