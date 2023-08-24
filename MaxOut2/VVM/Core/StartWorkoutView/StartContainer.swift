import SwiftUI
import MarqueeText
import BottomSheet
import HealthKit

struct StartContainer: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var model: StartViewModel
  @Binding var tabBarState: BarState
  
  let activities = HKWorkoutActivityType.allCases
  
  var body: some View {
    NavigationStack {
      ParallaxScrollView(background: Color.systemBackground, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 200) {
        grid
      } header: {
        Text("Ready when you are!")
          .font(.largeTitle.bold())
      }
    }
    .task { try? await model.loadCurrentUser() }
    .fullScreenCover(isPresented: $model.congratulationsScreen) {
      VStack(spacing: 40) {
        Text("CONGRATS MF")
        Button("Thanks?") {
          model.congratulationsScreen = false
        }
      }
    }
  }
  
  @ViewBuilder // MARK: - GRID
  private var grid: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]) {
      ForEach(activities, id: \.self) { activity in
        Button {
          model.startRoutine(activity)
          tabBarState = .hidden
        } label: {
          label(for: activity)
        }
        .disabled(model.inProgress)
      }
    }
  }
  
  @ViewBuilder // MARK: - ELEMENT
  private func label(for activityType: HKWorkoutActivityType) -> some View {
    GroupBox {
      HStack {
        
        Image(systemName: activityType.sfSymbol)
          .frame(width: 20)
          .foregroundColor(.primary)
        
        MarqueeText(text: activityType.commonName.capitalized, font: UIFont.preferredFont(forTextStyle: .body), leftFade: 5, rightFade: 2, startDelay: 3)
          .foregroundColor(.primary)
          .fontWeight(.semibold)

      }
    }
    .frame(maxWidth: .infinity, maxHeight: 60)
    .background(.regularMaterial)
    .cornerRadius(15)
  }
}
