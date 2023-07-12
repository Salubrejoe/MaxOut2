import SwiftUI


struct PickerCell: View {
  var exercise: Exercise
  
  let onTapAction: () -> ()
  
  init(exercise: Exercise, onTapAction: @escaping () -> Void) {
    self.exercise = exercise
    self.onTapAction = onTapAction
  }
  
  var body:  some View {
      HStack(spacing: 18) {
        BodyPartImageView(muscleGroup: exercise.muscleGroupImage,
                          equipment: exercise.equipmentImage,
                          size: 60,
                          color: exercise.color)
        HStack {
          mainLabel
          Spacer()
          checkMark
        }
      }
      .cellStyle()
      .animation(.easeIn, value: exercise.isSelected)
  }
}

extension PickerCell {
  
  @ViewBuilder // MARK: - CHECKMARK
  private var checkMark: some View {
    Image(systemName: "checkmark")
      .foregroundColor(.secondary)
      .font(.headline)
      .opacity(exercise.isSelected ? 1 : 0.01)
      .overlay {
        Rectangle()
          .frame(minWidth: 600)
          .frame(minHeight: 55 )
          .foregroundColor(.gray)
          .opacity(0.001)
          .onTapGesture {
            onTapAction()
          }
      }
  }
  
  
  @ViewBuilder // MARK: - MAIN LABEL
  private var mainLabel: some View {
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
      HStack {
        Text(exercise.equipment?.capitalized ?? "")
          .italic()
          .foregroundColor(.secondary)
          .font(.caption)
      }
    }
  }
}


// MARK: - .cellStyle()
extension View {
  func cellStyle() -> some View {
    self
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 10)
      .padding(.horizontal, 10)
      .background(Color.cell)
      .cornerRadius(10)
  }
}

struct ExerciseCell_Previews: PreviewProvider {
  static var previews: some View {
    PickerCell(exercise: Exercise.mockup) {}
  }
}
