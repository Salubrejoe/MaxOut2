import SwiftUI
import AlphabetScrollBar


struct ExListView: View {
  @StateObject private var model = ExercisesViewModel()
  @State private var isShowingTemplates = false
  
  // init
  @Binding var tabBarState: BarState
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        list
          .listStyle(.plain)
          .scrollDismissesKeyboard(.interactively)
          .scrollIndicators(.hidden)
        
        // SEARCH BAR
          .searchable(text: $model.searchText.bound, placement: .automatic, prompt: "Look up")
        
        ThreeWayPicker(model: model)
          .padding(.horizontal)
          .padding(.bottom, 60)
      }
      .navigationTitle("Exercises")
      .animation(.spring(), value: model.exercises)
      .toolbar { createButton }
      .onAppear{
        model.addListenerToFavourites()
        model.searchText = nil
      }
      .sheet(isPresented: $isShowingTemplates) {
        TemplatesPicker(model: model)
      }
    }
  }
}

extension ExListView {
  
  @ViewBuilder // MARK: - LIST
  private var list: some View {
    Group {
      AlphabetScrollView(collectionDisplayMode: .asList,
                         collection: model.exercises,
                         sectionHeaderFont: .caption.bold(),
                         sectionHeaderForegroundColor: .secondary,
                         resultAnchor: .center) { exercise in
        cell(for: exercise)
      }
    }
  }
  
  @ViewBuilder // MARK: - CELL
  private func cell(for exercise: Exercise) -> some View {
    NavigationLink {
      ExerciseDetailViiu(exercise: $model.exercises[model.indexOfItem(exercise, collection: model.exercises) ?? 0], tabBarState: $tabBarState)
      
    } label: {
      ExerciseListCell(exercise: exercise) {
        model.remove(exercise: exercise.id)
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
}

//// MARK: - LABEL
//struct ExerciseListCell: View {
//  let exercise: Exercise
//  let deleteAction: () -> ()
//  
//  var body: some View {
//    CellLabel(for: exercise)
//      .swipeActions(edge: .leading, allowsFullSwipe: true) {
//        Button {
//          deleteAction()
//        } label: {
//          Image(systemName: "trash")
//            .tint(.red)
//        }
//      }
//  }
//}





// MARK: - _Preview

struct ExListView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView(selection: .constant(.exercises), tabBarState: .constant(.large)) {
      ExListView(tabBarState: .constant(.large))
    }
  }
}
