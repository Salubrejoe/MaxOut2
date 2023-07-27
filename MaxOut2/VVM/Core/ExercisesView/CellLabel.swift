
import SwiftUI


struct CellLabel: View {
  let exercise: Exercise
  
  @Binding var isSelected: Bool
  let image: String
  
  let selectedAction: () -> ()
  
  var body: some View {
    HStack(spacing: 18) {
      
      BodyPartImageView(exercise: exercise, size: 60)
      
      vStackLabels
      
      Spacer()
      
      if isSelected {
        Button {
          selectedAction()
        } label: {
          Image(systemName: image)
            .foregroundColor(.primary)
            .imageScale(.large)
        }
      }
    }
    .multilineTextAlignment(.leading)
  }
  
  @ViewBuilder // MARK: - Label
  private var vStackLabels: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(exercise.muscleString)
        .font(.caption)
        .bold()
        .foregroundColor(exercise.muscle.color)
        .cornerRadius(3)
      Text(exercise.name.capitalized)
        .fontDesign(.rounded)
        .font(.headline)
        .foregroundColor(.primary)
      Text(exercise.equipmentString)
        .italic()
        .foregroundColor(.secondary)
        .font(.caption)
    }
  }
}
