
import SwiftUI

struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()

  var body: some View {
    NavigationStack {
      VStack {
        smallButtons
          .padding(.horizontal)
          .padding(.top, 20)
        
        List(model.exercises) { exercise in
          cell(for: exercise)
        }
        .edgesIgnoringSafeArea(.bottom)
        .cornerRadius(20)
//        .padding()
        .shadow(radius: 5)
      }
      .listStyle(.plain)
      .onAppear(perform: model.addListenerToFavourites)
      .animation(.spring(), value: model.exercises)
      .sheet(isPresented: $model.showingAddEdit) {
        NavigationStack {
          AddEditExerciseView(passedExercise: model.newExercise)
        }
      }
    }
    .background(Color.secondarySytemBackground)
  }
}

extension ExercisesListView {
  @ViewBuilder // MARK: - Small BUTTONS
  private var smallButtons: some View {
    VStack {
      HStack {
        Text("🦾 My Exercises").font(.largeTitle)
        Spacer()
      }
      HStack {
        SmallTsButton(text: "🖌️ Create", style: .secondary) {
          model.showingAddEdit = true
        }
        NavigationLink {
          TemplatesPickerView()
        } label: {
          Text("🚀 Discover")
            .tsButtonLabel(background: .primary, foreground: .systemBackground)
        }
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

