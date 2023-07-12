
import SwiftUI


struct TemplatesPickerView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = TemplatesPickerViewModel()
  
  var body: some View {
    NavigationStack {
      ZStack {
        exercisesList
        
        LetterPicker(selectedLetter: $model.selectedLetter, alphabet: model.alphabet)
          .animation(.spring(), value: model.selectedLetter)
      }
      .padding(.horizontal)
      .navigationTitle("🚀 Discover").navigationBarTitleDisplayMode(.inline)
      
      .animation(.spring(), value: model.templateExercises)  /// Animation
      
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          saveButton()
        }
      }
      .onAppear { model.loadJson() }
      .searchable(text: $model.searchText, placement: .navigationBarDrawer(displayMode: .always))  /// SearchBar
      .onChange(of: model.searchText) { _ in
        model.search()
      }///
    }
  }
}

extension TemplatesPickerView {
  
  @ViewBuilder // MARK: - LIST
  private var exercisesList: some View { 
    ScrollView(showsIndicators: false) {
      ScrollViewReader { pageScroller in
        LazyVGrid(columns: model.columns) {
        
        if model.selectedTemplates.count > 0 {
          HStack {
            Text("👍 Selected")
              .font(.subheadline)
            Spacer()
          }
          selectedList
          HStack {
            Text("🦿 Templates")
              .font(.subheadline)
            Spacer()
          }
        }
        
        Text("")
          .id("")
        
        
          ForEach(model.groupedExercises, id: \.0) { section in
            
            // MARK: LETTERED SECTIONS
            HStack {
              Text(section.0)
                .font(.caption2.bold())
              Spacer()
            }
            .id(section.0)
            .edgesIgnoringSafeArea(.horizontal)
            .foregroundColor(.secondary)
            .padding(.horizontal)
            
            
            ForEach(section.1) { exercise in
              
              // MARK: - PLAIN LIST
              PickerCell(exercise: exercise) {
                model.toggleIsSelected(exercise)
              }
            }
          }
      
          .onChange(of: model.selectedLetter) { newValue in
            withAnimation {
              pageScroller.scrollTo(newValue, anchor: .top)
            }
          }
        }
        .resignKeyboardOnDragGesture()
      }
    }
  }
  
  @ViewBuilder // MARK: - SELECTED LIST
  private var selectedList: some View {
    let exercises = model.selectedTemplates
    
    ForEach(exercises.indices, id: \.self) { index in
      PickerCell(exercise: exercises[index]) {
        model.selectedTemplates.remove(at: index)
        model.removeFromSelected(exercises[index])
      }
    }
    Divider()
  }
  
  // MARK: - SAVE BUTTON
  private func saveButton() -> some View {
    Button {
      withAnimation {
        model.addToExercises(model.selectedTemplates)
        model.selectedTemplates = []
        dismiss()
      }
      
    } label: {
      Text("Save")
        .bold()
    }
  }
}
