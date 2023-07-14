
import SwiftUI


struct TemplatesPickerView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = ExercisesViewModel()
  
  var body: some View {
    NavigationStack {
      ZStack {
        exercisesList
        
        VStack {
          Spacer()
          if model.selectedExercises.count > 0 {
            LargeTsButton(text: "Add \(model.selectedExercises.count)", background: Color.accentColor, textColor: .systemBackground) {
              model.add()
              dismiss()
            }
          }
        }
      }
      .padding(.horizontal)
      .navigationTitle("🚀 Discover").navigationBarTitleDisplayMode(.inline)
      .animation(.spring(), value: model.exercises)  /// Animation
      .onAppear { model.loadTemplateJson() }
      .searchable(text: $model.searchText, placement: .navigationBarDrawer(displayMode: .always))
      .onChange(of: model.searchText) { _ in
        model.search()
      }
    }
  }
}

extension TemplatesPickerView {
  
  @ViewBuilder // MARK: - LIST
  private var exercisesList: some View {
    ScrollViewReader { pageScroller in
      ScrollView(showsIndicators: false) {
        LazyVGrid(columns: model.columns) {
          
          if model.selectedExercises.count > 0 {
            selectedList
            selectionHeader("🦾 My Exercises")
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
        }
      }
      .overlay {
        HStack {
          Spacer()
          SectionIndexTitles(model: model, pageScroller: pageScroller) }
        }
    }
  }
  
  @ViewBuilder // MARK: - SELECTED LIST
  private var selectedList: some View {
    let exercises = model.selectedExercises
    
    selectionHeader("👍 Selected")
    
    ForEach(exercises.indices, id: \.self) { index in
      PickerCell(exercise: exercises[index]) {
        model.selectedExercises.remove(at: index)
        model.removeFromSelected(exercises[index])
      }
    }
    Divider()
  }
  
  @ViewBuilder
  private func selectionHeader(_ text: String) -> some View {
    HStack {
      Text(text)
        .font(.subheadline)
      Spacer()
    }
  }
}
