
import SwiftUI

struct BodyPartImageView: View {
  @Environment(\.colorScheme) var colorScheme
  let exercise: Exercise
  let size: CGFloat
  
  var body: some View {
    BodyPartImage(exercise: exercise, color: exercise.muscle.color)
      .padding(5)
      .frame(width: size, height: size)
      .overlay {
          HStack {
            Spacer()
            VStack {
              Spacer()
              EquipmentImage(exercise: exercise, size: size)
            }
          }
          .offset(x: 3, y: 3)
      }
  }
}

struct BodyPartImage: View {
  let exercise: Exercise
  let color: Color
  var body: some View {
    Image(systemName: exercise.activityType.hkType.sfSymbol)
      .resizable()
      .scaledToFit()
      .foregroundStyle(Color.systemBackground.gradient.shadow(.inner(color: color, radius: 1.5, y: 1)))
//      .shadow(color: color, radius: 2)
  }
}

struct EquipmentImage: View {
  let exercise: Exercise
  let size: CGFloat
  
  var body: some View {
    Image(exercise.equipmentType.image)
      .resizable()
      .scaledToFit()
      .colorMultiply(.primary)
      .frame(width: size/3, height: size/3)
      .padding(4)
      .background(.ultraThinMaterial)
      .opacity(exercise.equipmentType == .body ? 0 : 1)
      .clipShape(Circle())
  }
}
