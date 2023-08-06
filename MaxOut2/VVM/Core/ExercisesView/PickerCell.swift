
import SwiftUI
import Combine

struct PickerCell: View {
  @ObservedObject var model: ExercisesViewModel
  let exercise: Exercise
  @State private var isSelected = false
  let action: () -> ()
  
  @State private var isSelectedCancellable: AnyCancellable?
  
  var body: some View {
    HStack {
      if isSelected {
        Rectangle()
          .frame(width: 6)
          .foregroundStyle(Color.accentColor.gradient)
      }
      CellLabel(for: exercise)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
    .background(isSelected ? Color.secondarySytemBackground : Color.clear)
    .cornerRadius(20)
    .animation(.spring(), value: isSelected)
    .onTapGesture {
      isSelected.toggle()
      action()
    }
    .onReceive(model.passthrough) { _ in
      isSelected = false
    }
  }
}
