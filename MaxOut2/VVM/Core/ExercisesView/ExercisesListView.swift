
import SwiftUI


struct ExercisesListView: View {
  @Binding var tabBarSize: ContainerSize
  @StateObject private var model = ExercisesViewModel()
  
  @State private var isShowingTemplates = false
  
  var body: some View {
    NavigationStack {
      ScrollViewReader { pageScroller in
        ZStack(alignment: .bottom) {
          
            List {
              ForEach(model.groupedExercises, id: \.0) { section in
                actualList(section)
              }
              
              Spacer(minLength: 100)
            }
            .searchable(text: $model.searchText.bound, placement: .automatic, prompt: "Look up")
            .scrollDismissesKeyboard(.interactively)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
          
          
          VStack {
            ThreeWayPicker(model: model)
              .padding()
          }
          .padding(.bottom, 30)
        }
        .navigationTitle("Exercises")
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
        model.searchText = nil
      }
      .sheet(isPresented: $isShowingTemplates) {
        TemplatesPicker(model: model)
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
    
    
//    ForEach(section.1) { exercise in
//      let exerciseBinding = Binding<Exercise>(
//        get: { return exercise },
//        set: { newValue in model.selectedExercise = newValue }
//      )
//      NavigationLink(destination: ExerciseDetailView(exercise: $model.selectedExercise, model: model)) {
//        ExerciseListCell(exercise: exercise) {
//          model.remove(exercise: exercise.id)
//        }
//      }
//    }
    
    ForEach(section.1) { exercise in
      NavigationLink {
        ExerciseDetailViiu(exercise: $model.exercises[model.indexOfItem(exercise, collection: model.exercises) ?? 0])
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
  let deleteAction: () -> ()
  
  var body: some View {
    CellLabel(for: exercise)
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
        Button {
          deleteAction()
        } label: {
          Image(systemName: "trash")
            .foregroundColor(.red)
        }
//        .tint(Color(.systemRed))
      }
  }
}
