
import SwiftUI



struct ExercisesListView: View {
  @StateObject private var model = ExercisesViewModel()
  @State private var isShowingTemplates = false
  
  @Binding var tabBarState: BarState

  var body: some View {
    NavigationStack {
      ScrollViewReader { pageScroller in
        ZStack(alignment: .bottom) {
          
          LiSt
          
          ThreeWayPicker(model: model, collection: model.exercises)
            .padding(.horizontal)
            .padding(.bottom, 60)
        }
        .navigationTitle("Exercises")
        .overlay { indexTitles(pageScroller: pageScroller) }
        .animation(.spring(), value: model.exercises)
        .toolbar { createButton }
        .onAppear{
          model.addListenerToFavourites()
          model.loadSelectedExercisesJson()
          model.searchText = nil
        }
        .sheet(isPresented: $isShowingTemplates) {
          TemplatesPicker(model: model)
        }
      }
    }
  }
}


extension ExercisesListView {
  @ViewBuilder // MARK: - LIST
  private var LiSt: some View {
    List {
      ForEach(model.groupedExercises, id: \.0) { section in
        actualList(section)
      }
      
      Spacer(minLength: 100)
    }
    .scrollDismissesKeyboard(.interactively)
    .listStyle(.plain)
    .scrollIndicators(.hidden)
    
    .searchable(text: $model.searchText.bound, placement: .automatic, prompt: "Look up")
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
      NavigationLink {
        ExerciseDetailViiu(exercise: $model.exercises[model.indexOfItem(exercise, collection: model.exercises) ?? 0], tabBarState: $tabBarState)
        
      } label: {
        ExerciseListCell(exercise: exercise) {
          model.remove(exercise: exercise.id)
        }
      }
    }
  }
  
  @ToolbarContentBuilder // MARK: - PLUS BUTTON
  private var createButton: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        isShowingTemplates.toggle()
      } label: {
        Image(systemName: "plus.circle.fill")
          .imageScale(.large)
          .foregroundColor(.primary)
      }
    }
  }
  
  @ViewBuilder // MARK: - ALPHA WHEEL
  private func indexTitles(pageScroller: ScrollViewProxy) -> some View {
    HStack {
      Spacer()
      SectionIndexTitles(alphabet: model.alphabet, selectedLetter: $model.selectedLetter, pageScroller: pageScroller)
    }
  }
}


// MARK: - _Preview
struct ExercisesList_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView(selection: .constant(.exercises), tabBarState: .constant(.large)) {
      ExercisesListView(tabBarState: .constant(.large))
    }
  }
}


// MARK: - CELL
struct ExerciseListCell: View {
  let exercise: Exercise
  let deleteAction: () -> ()

  var body: some View {
    CellLabel(for: exercise)
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
        Button {
          deleteAction()
        } label: {
          Image(systemName: "trash")
            .tint(.red)
        }
      }
  }
}



