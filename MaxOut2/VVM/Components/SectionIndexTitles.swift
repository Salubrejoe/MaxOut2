import SwiftUI

struct SectionIndexTitles: View {
  @ObservedObject var model: ExercisesViewModel
  let pageScroller: ScrollViewProxy
  
  @GestureState private var dragLocation: CGPoint = .zero

  var body: some View {

      VStack {
        ForEach(model.alphabet, id: \.self) { letter in
          Text(letter).font(.system(size: 12).bold())
            .fontDesign(.rounded)
            .frame(width: 30)
            .background(dragObserver(title: letter))
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
          .updating($dragLocation) { value, state, _ in
            state = value.location
            
        }
      )
      .animation(.spring(), value: model.selectedLetter)
  }
  
  
  /// METHODS
  func dragObserver(title: String) -> some View {
    GeometryReader { geometry in
      dragObserver(geometry: geometry, title: title)
    }
  }
  
  private func dragObserver(geometry: GeometryProxy, title: String) -> some View {
    if geometry.frame(in: .global).contains(dragLocation) {
      DispatchQueue.main.async {
        pageScroller.scrollTo(title, anchor: .center)
        model.haptics.prepare()
        if title != model.selectedLetter { model.haptics.impactOccurred() }
        model.selectedLetter = title
      }
    }
    return Rectangle().fill(Color.clear)
  }
}
