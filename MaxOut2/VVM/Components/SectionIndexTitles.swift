import SwiftUI

struct SectionIndexTitles: View {
  @ObservedObject var model: ExercisesViewModel
  let pageScroller: ScrollViewProxy
  
  @GestureState private var dragLocation: CGPoint = .zero

  var body: some View {

      VStack {
        ForEach(model.alphabet, id: \.self) { letter in
          Image(systemName: imageForHeader(for: letter))
            .foregroundStyle(Color.exerciseRing.gradient)
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
  
  private func imageForHeader(for activity: String) -> String {
    switch activity {
      case "weight lifting" : return "figure.strengthtraining.traditional"
      case "core training" : return "figure.core.training"
      case "high intensity interval training" : return "figure.highintensity.intervaltraining"
      case "flexibility" : return "figure.cooldown"
      case "elliptical" : return "figure.elliptical"
      case "jump rope" : return "figure.jumprope"
      case "rowing" : return "figure.rower"
      case "running" : return "figure.run"
      case "skating" : return "figure.skating"
      case "walking" : return "figure.walk"
      default: return ""
    }
  }
}
