
import SwiftUI


struct CellLabel: View {
  let exercise: Exercise
  
  init(for exercise: Exercise) {
    self.exercise = exercise
  }
  
  var body: some View {
    HStack(spacing: 18) {
      
      BodyPartImageView(exercise: exercise, size: 60)
      
      vStackLabels
      
      Spacer()
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
