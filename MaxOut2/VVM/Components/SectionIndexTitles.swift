import SwiftUI

struct SectionIndexTitles: View {
  
  let alphabet: [String]
  @Binding var selectedLetter: String
  let pageScroller: ScrollViewProxy
  
  @GestureState private var dragLocation: CGPoint = .zero
  let haptics = UIImpactFeedbackGenerator(style: .rigid)

  var body: some View {

      VStack {
        ForEach(alphabet, id: \.self) { letter in
          Text(letter)
            .font(.system(size: 12).bold())
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
      .animation(.spring(), value: selectedLetter)
      .padding(.trailing, 3)
      .background(Color.systemBackground.opacity(0.01))
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
        haptics.prepare()
        if title != selectedLetter { haptics.impactOccurred() }
        selectedLetter = title
      }
    }
    return Rectangle().fill(Color.systemBackground.opacity(0.001))
  }
}
