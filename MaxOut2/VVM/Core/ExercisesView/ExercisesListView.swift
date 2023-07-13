
import SwiftUI

struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()

  var body: some View {
    NavigationStack {
      VStack {
        smallButtons
          .padding(.horizontal)
        
        ScrollViewReader { pageScroller in
          List {
            ForEach(model.groupedExercises, id: \.0) { section in
              Section(section.0) {
                ForEach(section.1) { exercise in
                  cell(for: exercise)
                }
              }
            }
          }
          .overlay {
            HStack {
              Spacer()
              SectionIndexTitles(model: model, pageScroller: pageScroller)
                .padding(.trailing, 10)
                .background(Color.systemBackground.opacity(0.5))
            }
          }
        }
      }
      .listStyle(.plain)
      .navigationTitle("🦾 My Exercises")
      .navigationBarTitleDisplayMode(.large)
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
        TemplatesPickerView()
      } label: {
        Text("🚀 Discover")
          .tsButtonLabel(background: .primary, foreground: .systemBackground)
      }
    }
  }
  
  // MARK: - Nav LINK
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


// MARK: - CELL
struct ExerciseListCell: View {
  let exercise: Exercise
  
  let deleteAction: () -> ()
  
  var body: some View {
    CellLabel(exercise: exercise)
      .animation(.easeIn, value: exercise.isSelected)
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
        Button {
          deleteAction()
        } label: {
          Image(systemName: "trash")
        }
        .tint(Color(.systemRed))
      }
  }
}

