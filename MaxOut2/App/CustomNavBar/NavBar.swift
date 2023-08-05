import SwiftUI

struct NavBar: View {
  @State private var showingBackButton = true
  @State private var title = "Title"
  @State private var subtitle: String? = "Subtitle"
  
  var body: some View {
    ZStack {
      titleSection
     
      backButton
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding()
    .foregroundColor(.primary)
    .background(Color.secondarySytemBackground.ignoresSafeArea(edges: .top))
  }
  
  @ViewBuilder // MARK: - BACK
  private var backButton: some View {
    if showingBackButton {
      Button {
        //
      } label: {
        Image(systemName: "chevron.left")
      }
    }
  }
  
  @ViewBuilder // MARK: - TITLE
  private var titleSection: some View {
    VStack(spacing: 4) {
      Text(title)
        .font(.title)
        .fontWeight(.semibold)
      if let subtitle {
        Text(subtitle)
          .font(.headline)
      }
    }
  }
}

struct NavBar_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      NavBar()
      Spacer()
    }
  }
}
