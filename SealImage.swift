import SwiftUI

struct SealImage: View {
  let size: CGFloat
  let systemName: String
  
  var body: some View {
    Circle()
      .frame(width: size, height: size)
      .foregroundStyle(.background.shadow(.inner(color: .black, radius: 2)))
      .overlay {
        Image(systemName: systemName)
          .resizable()
          .scaledToFit()
          .frame(width: size/2, height: size/2)
          .foregroundColor(.exerciseRing)
          .shadow(color: .black, radius: 2)
      }
  }
}

struct SealImage_Previews: PreviewProvider {
  static var previews: some View {
    SealImage(size: 30, systemName: "figure.run")
  }
}
