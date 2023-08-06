import SwiftUI

struct NavBar: View {
  @Environment(\.dismiss) var dismiss
  
  let showingBackButton: Bool
  let title: String
  let subtitle: String?
  
  var body: some View {
    ZStack {
      titleSection
        .frame(maxWidth: .infinity)
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
        dismiss()
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
      NavBar(showingBackButton: false, title: "Guahahhah", subtitle: "Lorem ipsum quandrti vertice penis")
      Spacer()
    }
  }
}
