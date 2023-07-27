
import SwiftUI

struct BodyPartImageView: View {
  @Environment(\.colorScheme) var colorScheme
  let exercise: Exercise
  let size: CGFloat
  
  var body: some View {
    Image(exercise.muscle.muscleGroupImage)
      .resizable()
      .scaledToFit()
      .colorMultiply(exercise.muscle.color)
      .shadow(color: exercise.muscle.color, radius: 7, x: 0, y: 0)
      .padding(5)
      .frame(width: size, height: size)
      .overlay {
          HStack {
            Spacer()
            VStack {
              Spacer()
              Image(exercise.equipmentType.image)
                .resizable()
                .scaledToFit()
                .frame(width: size/2.5, height: size/2.5)
                .padding(3)
                .background(.ultraThinMaterial)
                .opacity(exercise.equipmentType == .body ? 0 : 1)
                .clipShape(Circle())
            }
          }
          .offset(x: 3, y: 3)
      }
  }
} 
