import SwiftUI
import Combine

struct TemplatesPicker: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject  var model: ExercisesViewModel
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        ScrollViewReader { pageScroller in
          ScrollView(showsIndicators: false) {
            
            LazyVGrid(columns: model.columns) {
              if !model.selectedExercises.isEmpty {
                selection
              }
              ForEach(model.groupedTemplates, id: \.0) { section in
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
              SectionIndexTitles(alphabet: model.alphabetTemplates, selectedLetter: $model.selectedLetter, pageScroller: pageScroller)
            }
          }
          .navigationTitle("🚀Discover")
          .navigationBarTitleDisplayMode(.inline)
        }
        
        ThreeWayPicker(model: model)
      }
      .toolbar { saveButton }
      .dismissButton()
      .animation(.spring(), value: model.selectedExercises)
      .onAppear { model.loadTemplates() }

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
  
  @ToolbarContentBuilder // MARK: - SAVE BUTTON
  private var saveButton: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        model.add()
        dismiss()
      } label: {
        Text("Save")
          .bold()
      }
    }
  }
}

// MARK: - PICKER CELL
struct PickerCell: View {
  @ObservedObject var model: ExercisesViewModel
  let exercise: Exercise
  @State private var isSelected = false
  let action: () -> ()
  
  @State private var isSelectedCancellable: AnyCancellable?
  
  var body: some View {
    HStack {
      if isSelected {
        Rectangle()
          .frame(width: 5)
          .foregroundColor(.accentColor)
      }
      CellLabel(for: exercise)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
    .background(isSelected ? Color.secondarySytemBackground : Color.clear)
    .cornerRadius(10)
    .animation(.spring(), value: isSelected)
    .onTapGesture {
      isSelected.toggle()
      action()
    }
    .onReceive(model.passthrough) { _ in
      isSelected = false
    }
  }
}

struct TemplatesPicker_Previews: PreviewProvider {
  static var previews: some View {
    TemplatesPicker(model: ExercisesViewModel())
  }
}
