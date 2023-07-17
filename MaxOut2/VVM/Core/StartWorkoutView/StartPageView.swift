
import SwiftUI

struct StartPageView: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  
  @ObservedObject var model: StartViewModel
  @Binding var showingLoginView: Bool
  
  // GRID LAYOUT
  let columns = [GridItem(.adaptive(minimum: 160))]
  
  var body: some View {
    NavigationStack {
      ParallaxScrollView(background: Color.systemBackground, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 500) {
        startButton
          .padding(.vertical)
      } header: {
        header(user: model.fitUser)
      }
    }
  }
}

extension StartPageView {
  
  // MARK: - HEADER
  private func header(user: FitUser) -> some View {
    ZStack {
      VStack {
        if let photoUrl = user.photoUrl {
          AsyncImage(url: URL(string: photoUrl))
            .frame(width: 50, height: 50)
            .cornerRadius(12)
        }
        Text("🏚️ Hi, \(model.fitUser.username ?? "Pizza Guy!")")
          .font(.largeTitle.bold())
        
        quickGrid
          .padding()
      }
      
      settings
    }
  }
  
  @ViewBuilder
  private var quickGrid: some View {
    LazyVGrid(columns: columns, spacing: 20) {
      NavigationLink {
        ExercisesListView()
      } label: {
        QuickActionButtonView()
      }
    }
  }
  
  @ViewBuilder // MARK: - START BUTTON
  private var startButton: some View {
    LargeTsButton(text: "Start a new workout", background: Color.accentColor, textColor: .systemBackground) {
      model.startRoutine()
      model.viewState = .inProgress
    }
  }
  
  @ViewBuilder // MARK: - SETTINGS
  private var settings: some View {
    VStack {
      HStack {
        Spacer()
        NavigationLink {
          ProfileView(showingLoginView: $showingLoginView, fitUser: $model.fitUser)
        } label: {
          Image(systemName: "gearshape")
            .imageScale(.large)
        }
      }
      Spacer()
    }
    .padding()
  }
}
