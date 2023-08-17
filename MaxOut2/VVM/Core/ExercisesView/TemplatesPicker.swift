import SwiftUI
import Combine

struct TemplatesPicker: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject  var model: ExercisesViewModel
//  @EnvironmentObject var motion: MotionManager
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        ScrollViewReader { pageScroller in
          ScrollView(showsIndicators: false) {
            
            LazyVGrid(columns: model.columns) {
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
        
        VStack(spacing: 3) {
          ThreeWayPicker(model: model, collection: model.templates)
            
          if model.selectedExercises.count > 0 {
            MOButton(text: "Save \(model.selectedExercises.count)", background: Color.accentColor, textColor: .white) {
              model.add()
              dismiss()
            }
          }
        }
        .padding([.bottom, .horizontal])
      }
      .dismissButton()
      .animation(.spring(), value: model.selectedExercises)
      .onAppear { model.loadTemplatesJson() }
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
      PickerCell(model: model, exercise: exercise) { model.select(exercise) }
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

struct TemplatesPicker_Previews: PreviewProvider {
  static var previews: some View {
    TemplatesPicker(model: ExercisesViewModel())
  }
}
