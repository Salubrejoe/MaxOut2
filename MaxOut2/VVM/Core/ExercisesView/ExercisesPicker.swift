import SwiftUI

struct ExercisesPicker: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var startModel: StartViewModel
  @StateObject var model = ExercisesViewModel()
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        ScrollViewReader { pageScroller in
          ScrollView(showsIndicators: false) {
            
            LazyVGrid(columns: model.columns) {
              ForEach(model.groupedExercises, id: \.0) { section in
                actualList(section, pageScroller: pageScroller)
              }
            }
            .padding(.bottom, 100)
            .padding(.horizontal)
          }
          .searchable(text: $model.searchText.bound, placement: .automatic, prompt: "Look up")
          .scrollDismissesKeyboard(.interactively)
          .overlay {
            HStack {
              Spacer()
              SectionIndexTitles(alphabet: model.alphabet, selectedLetter: $model.selectedLetter, pageScroller: pageScroller)
            }
          }
          .navigationTitle("")
          .navigationBarTitleDisplayMode(.inline)
        }
        
        VStack(spacing: 3) {
          ThreeWayPicker(model: model)
          if model.selectedExercises.count > 0 {
            LargeTsButton(text: "Add \(model.selectedExercises.count)", background: Color.accentColor, textColor: .white) {
              model.commitSelection(toRoutineVM: startModel)
              dismiss()
            }
          }
        }
        .padding([.bottom, .horizontal])
      }
      .dismissButton()
      .animation(.spring(), value: model.selectedExercises)
      .onAppear { model.addListenerToFavourites() }
    }
  }
  
  @ViewBuilder
  private func actualList(_ section: (String, [Exercise]), pageScroller: ScrollViewProxy) -> some View {
    HStack {
      Text(section.0)
        .font(.caption2.bold())
      Spacer()
    }
    
    .id(section.0)
    .foregroundColor(.secondary)
    
    
    ForEach(section.1) { exercise in
      PickerCell(model: model, exercise: exercise) { model.select(exercise, pageScroller: pageScroller) }
        .id(exercise.id)
    }
  }
  
  @ViewBuilder // MARK: - SELECTION
  private var selection: some View {
    HStack {
      Text("👍 SELECTED")
        .font(.caption2.bold())
      Spacer()
    }
    .foregroundColor(.secondary)
    
    
    ForEach(model.selectedExercises) { exercise in
      ExerciseListCell(exercise: exercise) {}
        .overlay {
          HStack {
            Spacer()
            Image(systemName: "xmark.circle.fill")
              .imageScale(.large)
              .padding(.trailing)
          }
        }
        .onTapGesture {
          model.deselect(exercise)
          model.passthrough.send()
        }
    }
    
    Divider()
      .padding(.vertical)
      .foregroundColor(.secondary)
  }
}

struct ExercisesPicker_Previews: PreviewProvider {
  static var previews: some View {
    ExercisesPicker()
  }
}
