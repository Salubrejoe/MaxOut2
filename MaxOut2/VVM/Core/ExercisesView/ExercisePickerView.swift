
import SwiftUI
import SwipeActions

struct ExercisePickerView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = ExercisesViewModel()
  @ObservedObject var routineModel: StartViewModel
  
  
  /// Optional is NOT a CLASS =>
  public init(routineModel: StartViewModel? = nil) {
    self.routineModel = routineModel ?? StartViewModel()
  }
  
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        VStack {
          
          smallButtons
          
          ScrollView(showsIndicators: false) {
            
            LazyVGrid(columns: columns, spacing: 6) {
              if model.selectedExercises.count > 0 {
                selectedList
              }
              alphaList
            }
          }
          .navigationTitle("🏋🏼‍♀️ Ready?")
          .navigationBarTitleDisplayMode(.inline)
          .onAppear(perform: model.addListenerToFavourites)
          .animation(.spring(), value: model.exercises)
          .toolbar { toolbarItems() }
          
          .searchable(text: $model.searchText, placement: .navigationBarDrawer(displayMode: .always))  /// SearchBar
          .onChange(of: model.searchText) { _ in
            model.search()
          }///
          
          /// "🖌️ Create"
          .sheet(isPresented: $model.showingAddEdit) {
            NavigationStack {
              AddEditExerciseView(passedExercise: model.newExercise)
            }
          }
        }
        
        if model.selectedExercises.count > 0 {
          LargeTsButton(text: "Add \(model.selectedExercises.count)", buttonColor: .accentColor, textColor: .systemBackground) {
            model.commitSelection(toRoutineVM: routineModel)
            dismiss()
          }
        }
      }
        .padding(.horizontal)
    }
  }
}


extension ExercisePickerView {
  
  @ViewBuilder // MARK: - Small BUTTONS
  private var smallButtons: some View {
    HStack {
      SmallTsButton(text: "🖌️ Create", style: .secondary) {
        model.showingAddEdit = true
      }
      NavigationLink {
        TemplatesPickerView(isShowing3WayPicker: $model.isShowing3WayPicker)
      } label: {
        Text("🚀 Discover")
          .tsButtonLabel(background: .primary, foreground: .systemBackground)
      }
    }
  }
  
  @ViewBuilder // MARK: - SELECTION
  private var selectedList: some View {
    
    HStack {
      Text("💪 Selected")
        .font(.subheadline)
      
      Spacer()
    }
    .padding(.top)
    .padding(.bottom, 7)
    
    let exercises = model.selectedExercises
    
    ForEach(exercises.indices, id: \.self) { index in
      PickerCell(exercise: exercises[index]) {
        model.selectedExercises.remove(at: index)
        model.removeFromSelected(exercises[index])
      }
    }
    Divider()
      .padding(.bottom, 2)
    
    HStack {
      Text("🦾 My Exercises")
        .font(.subheadline)
      Spacer()
    }
    .padding(.top)
    
  }
  
  @ViewBuilder // MARK: - LIST
  private var alphaList: some View {
    ForEach(model.exercises) { exercise in
      PickerCell(exercise: exercise) {
        model.toggleIsSelected(exercise)
      }
    }
  }
  
  @ToolbarContentBuilder // MARK: - TOOLBAR
  func toolbarItems() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button("Cancel") { dismiss() }
    }
  }
}
