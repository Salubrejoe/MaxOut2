
import SwiftUI

struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()

  var body: some View {
    SectionedList(model: model)
      .onAppear{ model.addListenerToFavourites() }
      .animation(.spring(), value: model.exercises)
  }
}



//extension ExercisesListView {
  //  //    @ViewBuilder // MARK: - Small BUTTONS
  //  //    private var smallButtons: some View {
  //  //      HStack {
  //  //        SmallTsButton(text: "🖌️ Create", style: .secondary) {
  //  //          model.showingAddEdit = true
  //  //        }
  //  //        NavigationLink {
  //  //          //        TemplatesPickerView()
  //  //        } label: {
  //  //          Text("🚀 Discover")
  //  //            .tsButtonLabel(background: .primary, foreground: .systemBackground)
  //  //        }
  //  //      }
  //  //    }
  //
  //  // MARK: - Nav LINK
  //  private func cell(for exercise: Exercise) -> some View {
  //    NavigationLink {
  //      AddEditExerciseView(passedExercise: exercise)
  //    } label: {
  //      ExerciseListCell(exercise: exercise) {
  //        model.remove(exercise: exercise.id)
  //      }
  //    }
  //  }
  //}
