
import SwiftUI

struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()

  init() {
    UITableView.appearance().showsVerticalScrollIndicator = false
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        
//        ScrollViewReader { pageScroller in
//          List {
//            ForEach(model.groupedExercises, id: \.0) { section in
//              Section {
//                ForEach(section.1) { exercise in
//                  cell(for: exercise)
//                }
//              } header: {
//                HStack {
//                  Image(systemName: imageForHeader(for: section.0))
//                    .imageScale(.large)
//                    .foregroundStyle(Color.exerciseRing.gradient)
//                  Text(section.0)
//                    .font(.headline)
//                }
//              }
//            }
//          }
//        }
        
        List(model.groupedExercises, id: \.0) { section in
          ForEach(section.0, id: \.self) { puff in
            
          }
        }
      }
      .listStyle(.sidebar)
      .navigationTitle("Activities")
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
  
  private func imageForHeader(for activity: String) -> String {
    switch activity {
      case "weight lifting" : return "figure.strengthtraining.traditional"
      case "core training" : return "figure.core.training"
      case "high intensity interval training" : return "figure.highintensity.intervaltraining"
      case "flexibility" : return "figure.cooldown"
      case "elliptical" : return "figure.elliptical"
      case "jump rope" : return "figure.jumprope"
      case "rowing" : return "figure.rower"
      case "running" : return "figure.run"
      case "skating" : return "figure.skating"
      case "walking" : return "figure.walk"
      default: return ""
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

