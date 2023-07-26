
import SwiftUI

struct BodyPartImageView: View {
  @Environment(\.colorScheme) var colorScheme
  let muscleGroup: String
  let equipment: String
  let size: CGFloat
  let color: Color
  
  var body: some View {
    Image(muscleGroup)
      .resizable()
      .scaledToFit()
      .colorMultiply(color)
      .padding(5)
      .frame(width: size, height: size)
      .overlay {
        if equipment != "" {
          HStack {
            Spacer()
            VStack {
              Spacer()
              Image(equipment)
                .resizable()
                .scaledToFit()
                .frame(width: size/2.5, height: size/2.5)
                .padding(3)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            }
          }
          .offset(x: 3, y: 3)
        }
      }
  }
}

//
//struct CategoryImageView: View {
//  @Environment(\.colorScheme) var colorScheme
//  let systemName: String
//  let size: CGFloat
//  let color: Color
//  
//  var body: some View {
//    Image(systemName: systemName)
//      .font(.system(size: size/1.7))
//      .frame(width: size, height: size)
//      .foregroundStyle(
//        Color.accentColor.gradient.shadow(
//          .inner(color: colorScheme == .dark ? .green.opacity(0.7) : .orange.opacity(0.5),
//                 radius: 2, x: 0, y: 0)
//        )
//      )
//      .cornerRadius(size/2)
//  }
//}
//
////struct CategoryImageView_Previews: PreviewProvider {
//  static let parts = [
//    "shoulder",
//    "front",
//    "back",
//    "leg",
//    "glutes",
//    "arm"
//  ]
//  static var previews: some View {
//    VStack(spacing: 30) {
//      ForEach(parts, id: \.self) {
//        BodyPartImageView(muscleGroup: $0, category: "stretching", size: 80, color: .green)
//      }
//    }
//  }
//}


