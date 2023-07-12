
import SwiftUI

struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()

  var body: some View {
    NavigationStack {
      VStack {
        smallButtons
          .padding(.horizontal)
        
        List(model.exercises) { exercise in
          cell(for: exercise)
        }
      }
      .listStyle(.plain)
      .navigationTitle("🦾 My Exercises")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear(perform: model.addListenerToFavourites)
      .animation(.spring(), value: model.exercises)
      .sheet(isPresented: $model.showingAddEdit) {
        NavigationStack {
          AddEditExerciseView(passedExercise: model.newExercise)
        }
      }
    }
  }
}

extension ExercisesListView {
  @ViewBuilder // MARK: - Small BUTTONS
  private var smallButtons: some View {
    HStack {
      SmallTsButton(text: "🖌️ Create", style: .secondary) {
        model.showingAddEdit = true
      }
      NavigationLink {
        TemplatesPickerView(isShowing3WayPicker: $model.isShowing3WayPicker)
      } label: {
        Text("🚀 Discover")
          .tsButtonLabel(background: .backgroundInverted, foreground: .systemBackground)
      }
    }
  }
  
  // MARK: - CELL
  private func cell(for exercise: Exercise) -> some View {
    NavigationLink {
      AddEditExerciseView(passedExercise: exercise)
    } label: {
      ExerciseListCell(exercise: exercise) {
        model.remove(exercise: exercise.id)
      }
    }
  }
}

