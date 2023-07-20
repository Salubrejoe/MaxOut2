
import SwiftUI

struct DiaryView: View {
  enum CoordinateSpaces {
    case scrollView
  }
  @StateObject private var model = DiaryViewModel()
  @StateObject var manager = HealthKitManager()
  @Binding var showingLoginView: Bool
  
  
  var body: some View {
    NavigationStack {
      ParallaxScrollView(background: Color.clear, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 100) {
        WidgetGrid().environmentObject(manager)
      } header: {
        header
      }
      .navigationTitle("Diary").navigationBarTitleDisplayMode(.inline)
      .toolbar { toolbar }
      .task { try? await model.loadCurrentUser() }
    }
    .environmentObject(manager)
  }
}

extension DiaryView {
  
  @ViewBuilder // MARK: - Header
  private var header: some View {
    List {
      NavigationLink {
        ProfileView(model: model, showingLoginView: $showingLoginView)
      } label: {
        ProfileLabel(user: model.user)
      }
    }.listStyle(.plain)
  }
  
    
  @ToolbarContentBuilder // MARK: - TOOLBAR
  private var toolbar: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      NavigationLink {
        // SettingsView
      } label: {
        Image(systemName: "gearshape")
      }
    }
  }
}
  

// MARK: - PROFILE LABEL
struct ProfileLabel: View {
  let user: FitUser
  var body: some View {
    HStack(spacing: 12) {
      if let urlString = user.photoUrl, let url = URL(string: urlString) {
        AsyncImage(url: url) { image in
          image
            .resizable()
            .scaledToFill()
        } placeholder: {
          ProgressView()
        }
        .frame(width: 46, height: 46)
        .background(Color.gray)
        .clipShape(Circle())
      }
      else {
        Text(user.firstLetter)
          .font(.title)
          .fontDesign(.rounded)
          .fontWeight(.heavy)
          .foregroundColor(.systemBackground)
          .frame(width: 46, height: 46)
          .background(Color(hex: user.color ?? ""))
          .clipShape(Circle())
      }
      VStack(alignment: .leading) {
        Text(user.username ?? "Pizza guy")
          .font(.title3.bold())
        HStack {
          Text(user.ageString)
          Text(user.heightString)
        }
        .font(.caption)
        .foregroundColor(.gray)
      }
    }
    .padding(.horizontal)
  }
}


struct DiaryView_Previews: PreviewProvider {
  static var previews: some View {
    DiaryView(showingLoginView: .constant(false))
  }
}
