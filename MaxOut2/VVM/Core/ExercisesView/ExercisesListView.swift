
import SwiftUI



struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()
  
  @State private var isShowingTemplates = false
  
  var body: some View {
    NavigationStack {
      ScrollViewReader { pageScroller in
        VStack {
          ThreeWayPicker(model: model)
            .padding(.horizontal)
          
          List {
            
            ForEach(model.groupedExercises, id: \.0) { section in
              actualList(section)
            }
          }
          .scrollDismissesKeyboard(.interactively)
          .listStyle(.plain)
          .scrollIndicators(.hidden)
          .searchable(text: $model.searchText.bound, placement: .automatic, prompt: "Look up")
        }
        .navigationTitle("Exercises")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
          HStack {
            Spacer()
            SectionIndexTitles(alphabet: model.alphabet, selectedLetter: $model.selectedLetter, pageScroller: pageScroller)
          }
        }
      }
      .animation(.spring(), value: model.exercises)
      .toolbar { createButton }
      .onAppear{
        model.addListenerToFavourites()
      }
      .sheet(isPresented: $isShowingTemplates) {
        TemplatesPicker()
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
      .transition(.opacity)
    }
  }
  
  @ToolbarContentBuilder // MARK: - TOOLBAR
  private var createButton: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        isShowingTemplates.toggle()
      } label: {
        HStack(spacing: 0){
          Image(systemName: "plus.circle.fill")
            .imageScale(.large)
        }
        .foregroundColor(.primary)
      }
    }
  }
}


// MARK: - CELL
struct ExerciseListCell: View {
  let exercise: Exercise
  @State private var isSelected: Bool = false
  let deleteAction: () -> ()
  
  var body: some View {
    CellLabel(exercise: exercise, isSelected: $isSelected, image: "checkmark", selectedAction: {
      //
    })
      
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
