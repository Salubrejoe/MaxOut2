import SwiftUI

final class SectionIndexViewModel: ObservableObject {
  init() { loadJson() }
  
  @Published var selectedLetter = ""
  
  var exercises: [Exercise] = []
  
  /// Grid columns
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  let haptics = UIImpactFeedbackGenerator()
  
  // MARK: - SECTIONED EXERCISES
  var groupedExercises: [(String, [Exercise])] {
    let sortedItems = exercises.sorted { $0.name < $1.name }
    let grouped = Dictionary(grouping: sortedItems) { String($0.name.prefix(1)) }
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  var alphabet: [String] {
    var a = [""]
    for exercise in groupedExercises {
      a.append(exercise.0)
    }
    return a
  }
  
  // MARK: - LOAD JSON
  func loadJson() {
    self.exercises = []
    let result: ExercisesArray = Bundle.main.decode("exercises.json")
    
    let decodedExercises = result.exercises
    
    exercises = decodedExercises
  }
}

struct SectionIndexView: View {
  @StateObject private var model = ExercisesViewModel()
  
  var body: some View {
    ScrollViewReader { pageScroller in
      exercisesTableView
        .overlay { SectionIndexTitles(model: model, pageScroller: pageScroller) }
    }
    .animation(.spring(), value: model.selectedLetter)
  }
}

extension SectionIndexView {
  
  @ViewBuilder // MARK: - LIST
  private var exercisesTableView: some View {
    ScrollView(showsIndicators: false) {
      tableView
    }
    .scrollDismissesKeyboard(.interactively)
  }
  
  
  @ViewBuilder
  private var tableView: some View {
    LazyVGrid(columns: model.columns) {
      
      ForEach(model.groupedExercises, id: \.0) { section in
        sectionIndexTitle(section.0)
        
        ForEach(section.1) { exercise in
          PickerCell(exercise: exercise) {}
        }
      }
    }
  }
  
  @ViewBuilder // MARK: - SECTION TITLE
  private func sectionIndexTitle(_ section: String) -> some View {
    HStack {
      Text(section)
        .font(.caption2.bold())
      Spacer()
    }
    .id(section)
    .edgesIgnoringSafeArea(.horizontal)
    .foregroundColor(.primary)
    .padding(.horizontal)
  }
}

struct SectionIndexView_Previews: PreviewProvider {
  static var previews: some View {
    SectionIndexView()
  }
}


struct SectionIndexTitles: View {
  @ObservedObject var model: ExercisesViewModel
  let pageScroller: ScrollViewProxy
  
  @GestureState private var dragLocation: CGPoint = .zero

  var body: some View {
    HStack {
      Spacer()
      VStack {
        ForEach(model.alphabet, id: \.self) { letter in
          Text(letter).font(.system(size: 13).bold())
            .fontDesign(.rounded)
            .background(dragObserver(title: letter))
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
          .updating($dragLocation) { value, state, _ in
            state = value.location
        }
      )
    }
    .padding(.trailing)
  }
  
  func dragObserver(title: String) -> some View {
    GeometryReader { geometry in
      dragObserver(geometry: geometry, title: title)
    }
  }
  
  // This function is needed as view builders don't allow to have
  // pure logic in their body.
  private func dragObserver(geometry: GeometryProxy, title: String) -> some View {
    if geometry.frame(in: .global).contains(dragLocation) {
      // we need to dispatch to the main queue because we cannot access to the
      // `ScrollViewProxy` instance while the body is rendering
      DispatchQueue.main.async {
        pageScroller.scrollTo(title, anchor: .top)
        model.selectedLetter = title
      }
    }
    return Rectangle().fill(Color.clear)
  }
}
