
import SwiftUI

struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()

  var body: some View {
    NavigationStack {
      ScrollViewReader { pageScroller in
        VStack {
          smallButtons
          List(sections, id: \.0) { section in
            actualList(section)
          }
          .listStyle(.plain)
          .scrollIndicators(.hidden)
        }
        .navigationTitle("Exercises")
        .overlay {
          HStack {
            Spacer()
            SectionIndexTitles(alphabet: alphabet, selectedLetter: $model.selectedLetter, pageScroller: pageScroller)
          }
        }
      }
      .onAppear{
        model.addListenerToFavourites()
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
    }
  }
  
  
  @ViewBuilder
  private var smallButtons: some View {
    HStack {
      EQPicker(model: model)
      MGPicker(model: model)
      APicker(model: model)
    }
    .padding(.horizontal)
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
