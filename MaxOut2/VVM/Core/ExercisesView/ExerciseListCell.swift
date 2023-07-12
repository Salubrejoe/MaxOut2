
import SwiftUI

struct ExerciseListCell: View {
  var exercise: Exercise
  
  let deleteAction: () -> ()
  
  var body: some View {
    HStack(spacing: 18) {
      BodyPartImageView(muscleGroup: exercise.muscleGroupImage, equipment: exercise.equipmentImage, size: 60, color: exercise.color)
      
      vStackLabels
      Spacer()
    }
    .multilineTextAlignment(.leading)
    .animation(.easeIn, value: exercise.isSelected)
    .swipeActions(edge: .leading, allowsFullSwipe: true) {
      Button {
        deleteAction()
      } label: {
        Image(systemName: "trash")
      }
      .tint(Color(.systemRed))
    }
  }
}

extension ExerciseListCell {
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

