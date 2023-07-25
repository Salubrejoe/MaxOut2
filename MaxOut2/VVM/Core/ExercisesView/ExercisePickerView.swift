//
//import SwiftUI
//import SwipeActions
//
//struct ExercisePickerView: View {
//  @Environment(\.dismiss) var dismiss
//  @StateObject private var model = ExercisesViewModel()
//  @ObservedObject var routineModel: StartViewModel
//  
//  
//  /// Optional is NOT a CLASS =>
//  public init(routineModel: StartViewModel? = nil) {
//    self.routineModel = routineModel ?? StartViewModel()
//  }
//  
//  let columns = [GridItem(.adaptive(minimum: 300))]
//  
//  var body: some View {
//    NavigationStack {
//      ZStack(alignment: .bottom) {
//        VStack {
//          smallButtons
//          exercisesList
//        }
//        
//        if model.selectedExercises.count > 0 {
//          LargeTsButton(text: "Add \(model.selectedExercises.count)", background: Color.accentColor, textColor: .systemBackground) {
//            model.commitSelection(toRoutineVM: routineModel)
//            dismiss()
//          }
//        }
//      }
//      .padding(.horizontal)
//      .navigationTitle("🏋🏼‍♀️ Ready?")
//      .navigationBarTitleDisplayMode(.inline)
//      .onAppear(perform: model.addListenerToFavourites)
//      .animation(.spring(), value: model.exercises)
//      .toolbar { toolbarItems() }
//      .searchable(text: $model.searchText, placement: .navigationBarDrawer(displayMode: .always))
//      .onChange(of: model.searchText) { _ in
//        model.search()
//      }
//      
//      /// "🖌️ Create"
//      .sheet(isPresented: $model.showingAddEdit) {
//        NavigationStack {
//          AddEditExerciseView(passedExercise: model.newExercise)
//        }
//      }
//    }
//  }
//}
//
//
//
//
//extension ExercisePickerView {
//  @ViewBuilder // MARK: - Small BUTTONS
//  private var smallButtons: some View {
//    HStack {
//      SmallTsButton(text: "🖌️ Create", style: .secondary) {
//        model.showingAddEdit = true
//      }
//      NavigationLink {
////        TemplatesPickerView()
//      } label: {
//        Text("🚀 Discover")
//          .tsButtonLabel(background: .primary, foreground: .systemBackground)
//      }
//    }
//  }
//  
//  @ViewBuilder // MARK: - LIST
//  private var exercisesList: some View {
//    ScrollViewReader { pageScroller in
//      ScrollView(showsIndicators: false) {
//        LazyVGrid(columns: model.columns) {
//          
//          if model.selectedExercises.count > 0 {
//            selectedList
//            selectionHeader("🦾 My Exercises")
//          }
//          
//          Text("")
//            .id("")
//          
//          ForEach(model.groupedExercises, id: \.0) { section in
//            
//            // MARK: LETTERED SECTIONS
//            HStack {
//              Text(section.0)
//                .font(.caption2.bold())
//              Spacer()
//            }
//            .id(section.0)
//            .edgesIgnoringSafeArea(.horizontal)
//            .foregroundColor(.secondary)
//            .padding(.horizontal)
//            
//            
//            ForEach(section.1) { exercise in
//              
//              // MARK: - PLAIN LIST
//              PickerCell(exercise: exercise) {
//                model.toggleIsSelected(exercise)
//              }
//            }
//          }
//        }
//      }
//      .overlay {
//        HStack {
//          Spacer()
//          SectionIndexTitles(model: model, pageScroller: pageScroller) }
//      }
//    }
//  }
//  
//  @ViewBuilder // MARK: - SELECTED LIST
//  private var selectedList: some View {
//    let exercises = model.selectedExercises
//    
//    selectionHeader("👍 Selected")
//    
//    ForEach(exercises.indices, id: \.self) { index in
//      PickerCell(exercise: exercises[index]) {
//        model.selectedExercises.remove(at: index)
//        model.removeFromSelected(exercises[index])
//      }
//    }
//    Divider()
//  }
//  
//  @ViewBuilder
//  private func selectionHeader(_ text: String) -> some View {
//    HStack {
//      Text(text)
//        .font(.subheadline)
//      Spacer()
//    }
//  }
//  
//  @ToolbarContentBuilder // MARK: - TOOLBAR
//  func toolbarItems() -> some ToolbarContent {
//    ToolbarItem(placement: .navigationBarLeading) {
//      Button("Cancel") { dismiss() }
//    }
//  }
//}
//  
//  
//// MARK: - PICKER CELL
//struct PickerCell: View {
//  var exercise: Exercise
//  
//  let onTapAction: () -> ()
//  
//  init(exercise: Exercise, onTapAction: @escaping () -> Void) {
//    self.exercise = exercise
//    self.onTapAction = onTapAction
//  }
//  
//  var body:  some View {
//    HStack(spacing: 18) {
//      CellLabel(exercise: exercise)
//      Spacer()
//      checkMark
//    }
//    .cellStyle()
//    .animation(.easeIn, value: exercise.isSelected)
//  }
//}
//
//extension PickerCell {
//  
//  @ViewBuilder // MARK: - CHECKMARK
//  private var checkMark: some View {
//    Image(systemName: "checkmark")
//      .foregroundColor(.secondary)
//      .font(.headline)
//      .opacity(exercise.isSelected ? 1 : 0.01)
//      .overlay {
//        Rectangle()
//          .frame(minWidth: 600)
//          .frame(minHeight: 55 )
//          .foregroundColor(.gray)
//          .opacity(0.001)
//          .onTapGesture {
//            onTapAction()
//          }
//      }
//  }
//}
