import SwiftUI

struct TemplatesPicker: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = ExercisesViewModel()
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        ScrollViewReader { pageScroller in
          ScrollView(showsIndicators: false) {
            ThreeWayPicker(model: model)
            LazyVGrid(columns: model.columns) {
              if !model.selectedExercises.isEmpty {
                selection
              }
              ForEach(model.groupedTemplates, id: \.0) { section in
                actualList(section)
              }
            }
            .padding(.bottom, 100)
          }
          .searchable(text: $model.searchText.bound, placement: .automatic, prompt: "Look up")
          .scrollDismissesKeyboard(.interactively)
          .overlay {
            HStack {
              Spacer()
              SectionIndexTitles(alphabet: model.alphabetTemplates, selectedLetter: $model.selectedLetter, pageScroller: pageScroller)
            }
          }
          .padding(.horizontal)
          .navigationTitle("🚀Discover")
          .navigationBarTitleDisplayMode(.inline)
        }
        
        LargeTsButton(text: "Create New", background: .regularMaterial, textColor: .accentColor) {
          //
        }
        .padding()
        .shadow(radius: 5)
      }
      .toolbar { saveButton }
      .dismissButton()
      .animation(.spring(), value: model.selectedExercises)
      .onAppear { model.loadTemplates() }

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
        //
      }
      .transition(.opacity)
      .onTapGesture {
        model.select(exercise)
      }
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

struct TemplatesPicker_Previews: PreviewProvider {
  static var previews: some View {
    TemplatesPicker()
  }
}
