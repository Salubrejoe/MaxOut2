
import SwiftUI


struct CellLabel: View {
  let exercise: Exercise
  
  var body: some View {
    HStack(spacing: 18) {
      BodyPartImageView(muscleGroup: exercise.muscleGroupImage, equipment: exercise.equipmentImage, size: 60, color: exercise.color)
      
      vStackLabels
      Spacer()
    }
    .multilineTextAlignment(.leading)
  }
  
  @ViewBuilder // MARK: - Label
  private var vStackLabels: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(exercise.muscleGroup.capitalized)
        .font(.caption)
        .bold()
        .foregroundColor(exercise.color.opacity(0.9))
        .cornerRadius(3)
      Text(exercise.name.capitalized)
        .fontDesign(.rounded)
        .font(.headline)
        .foregroundColor(.primary)
      Text(exercise.equipment?.capitalized ?? "")
        .italic()
        .foregroundColor(.secondary)
        .font(.caption)
    }
  }
}
