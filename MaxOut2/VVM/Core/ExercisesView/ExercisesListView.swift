
import SwiftUI

struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()
  
  init() {
    UITableView.appearance().showsVerticalScrollIndicator = false
  }
  
  
  var body: some View {
    NavigationStack {
      VStack {
        ActivitiesWheel(model: model)
        
        ScrollViewReader { pageScroller in
          List {
            ForEach(model.selectedActivity.groupedExercises, id: \.0) { section in
              
              // MARK: LETTERED SECTIONS
              HStack {
                Text(section.0)
                  .font(.caption2.bold())
                Spacer()
              }
              .id(section.0)
              .foregroundColor(.secondary)
              
              
              ForEach(section.1) { exercise in
                // MARK: - PLAIN LIST
                ExerciseListCell(exercise: exercise) {
                  model.remove(exercise: exercise.id)
                }
              }
            }
            LargeTsButton(text: "Create New Exercise", background: .ultraThinMaterial, textColor: .primary) {
              //
            }
            .padding(.vertical)
          }
          .listStyle(.plain)
          .scrollIndicators(.hidden)
          .overlay {
            HStack {
              Spacer()
              SectionIndexTitles(alphabet: model.selectedActivity.alphabet, selectedLetter: $model.selectedLetter, pageScroller: pageScroller)
            }
          }
        }
        .navigationTitle("Exercises")
        .navigationBarTitleDisplayMode(.large)
        .onAppear{
          model.addListenerToFavourites()
          model.selectedActivity = model.groupedActivities.first ?? NewActivity(id: "", name: "", exercises: [])
        }
        .animation(.spring(), value: model.exercises)
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
          //        TemplatesPickerView()
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
  
