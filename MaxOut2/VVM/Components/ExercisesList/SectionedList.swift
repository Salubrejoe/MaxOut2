import SwiftUI

struct SectionedList: View {
  enum CoordinateSpaces {
    case scrollView
  }
  
  @ObservedObject var model: ExercisesViewModel
  
  init(model: ExercisesViewModel) {
    self.model = model
  }
  
  var body: some View {
    ScrollViewReader { pageScroller in
      ZStack(alignment: .trailing) {
        ParallaxScrollView(background: Color.systemBackground, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 140) {
          
          LazyVGrid(columns: model.columns) {
            ForEach(sections, id: \.0) { section in
              actualList(section)
            }
            
            LargeTsButton(text: "Create new exercise", background: Color.accentColor.gradient, textColor: .primary) {
              //
            }.padding(.vertical)
          }
          
        } header: {
          HStack {
            APicker(model: model)
            MuscleGroupPicker(model: model)
          }
        }
        
        HStack {
          Spacer()
          SectionIndexTitles(alphabet: alphabet, selectedLetter: $model.selectedLetter, pageScroller: pageScroller)
        }
      }
    }
  }
  
  
  @ViewBuilder
  private func actualList(_ section: (String, [Exercise])) -> some View {
    HStack {
      Text(section.0)
        .font(.caption2.bold())
      Spacer()
    }
    .id(section.0)
    .foregroundColor(.secondary)
    
    
    ForEach(section.1) { exercise in
      ExerciseListCell(exercise: exercise) {
        model.remove(exercise: exercise.id)
      }
      .padding()
      .background(.ultraThinMaterial)
      .cornerRadius(10)
    }
  }
  
  private var sections: [(String, [Exercise])] {
    if let selectedActivity = model.selectedActivity { return selectedActivity.groupedExercises }
    else { return model.groupedExercises }
  }
  
  private var alphabet: [String] {
    if let selectedActivity = model.selectedActivity {
      if selectedActivity.alphabet.count > 4 {
        return selectedActivity.alphabet
      }
      else {
        return []
      }
    }
    else { return model.alphabet }
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
