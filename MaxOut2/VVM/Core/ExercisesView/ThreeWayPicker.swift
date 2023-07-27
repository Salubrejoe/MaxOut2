
import SwiftUI


struct ThreeWayPicker: View {
  @ObservedObject var model: ExercisesViewModel
  
  var body: some View {
    HStack(spacing: 3) {
      EQPicker(selectedEquipment: $model.selectedEquipment)
      MGPicker(selectedMuscle: $model.selectedMuscle)
      APicker(selectedActivityType: $model.selectedActivityType)
    }
  }
}


// MARK: - MGPICKER
struct MGPicker: View {
  @Binding var selectedMuscle: Muscle?
  
  let muscles  : [Muscle] = Muscle.allCases
  
  var body: some View {
    Menu {
      Section {
        Button {
          selectedMuscle = nil
        } label: {
          Text("See All").bold()
        }
      }
      
      Section {
        ForEach(muscles, id: \.self) { muscle in
          Button {
            selectedMuscle = muscle
          } label: {
            HStack {
              Image(muscle.muscleGroupImage)
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
              Text(muscle.rawValue.capitalized)
            }
          }
        }
      }
    } label: {
      label()
    }
  }
  
  @ViewBuilder // MARK: - Label
  private func label() -> some View {
    HStack(spacing: 0) {
      
      if let selectedMuscle {
        Image(selectedMuscle.muscleGroupImage)
          .resizable()
          .scaledToFit()
          .colorMultiply(.primary)
          .frame(width: 20, height: 20)
          .padding(.vertical, 7)
          .padding(.trailing, 5)
          
      }
      Text(selectedMuscle?.rawValue.capitalized ?? "Muscle Group")
        .foregroundColor(.primary)
    }
    .labelForPickers(isSelected: selectedMuscle != nil)
  }
  
  private func deselect() { self.selectedMuscle = nil }
}



// MARK: - APICKER
struct APicker: View {
  @Binding var selectedActivityType: ActivityType?
  
  let activityTypes : [ActivityType] = ActivityType.allCases
  
  var body: some View {
    Menu {
      Section {
        Button {
          selectedActivityType = nil
        } label: {
          Text("See All").bold()
        }
      }
      
      Section {
        ForEach(activityTypes, id: \.self) { type in
          Button {
            selectedActivityType = type
          } label: {
            Label(type.rawValue.capitalized, systemImage: type.hkType.sfSymbol)
          }
        }
      }
    } label: {
      label()
    }
  }
  
  @ViewBuilder // MARK: - Label
  private func label() -> some View {
    HStack(spacing: 5) {
      if let selectedActivityType {
        Image(systemName: selectedActivityType.hkType.sfSymbol)
          .frame(width: 20, height: 20)
          .foregroundColor(.primary)
      }
      Text(selectedActivityType?.hkType.commonName.capitalized ?? "Category")
        .foregroundColor(.primary)
    }
    .labelForPickers(isSelected: selectedActivityType != nil)
  }
}


// MARK: - EQPICKER
struct EQPicker: View {
  @Binding var selectedEquipment: EquipmentType?
  
  let equipmentTypes  : [EquipmentType] = EquipmentType.allCases
  
  var body: some View {
    Menu {
      Section {
        Button {
          selectedEquipment = nil
        } label: {
          Text("See All").bold()
        }
      }
      
      Section {
        ForEach(equipmentTypes, id: \.self) { eqType in
          Button {
            selectedEquipment = eqType
          } label: {
            HStack {
              Image(eqType.image)
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .padding(2)
              Text(eqType.rawValue.capitalized)
            }
          }
        }
      }
    } label: {
      label()
    }
  }
  
  @ViewBuilder // MARK: - Label
  private func label() -> some View {
    HStack(spacing: 5) {
      if let selectedEquipment, selectedEquipment != .body {
        Image(selectedEquipment.image)
          .resizable()
          .scaledToFit()
          .frame(width: 20, height: 20)
      }
      Text(selectedEquipment?.rawValue.capitalized ?? "Equipment")
        .foregroundColor(.primary)
    }
    .labelForPickers(isSelected: selectedEquipment != nil)
  }
}


extension View {
  func labelForPickers(isSelected: Bool) -> some View {
    self
      .bold()
      .minimumScaleFactor(0.8)
      .padding(.horizontal, 7)
      .multilineTextAlignment(.leading)
      .font(.footnote)
      .frame(maxWidth: .infinity)
      .frame(maxHeight: 38)
//      .background(isSelected ? Color.systemBackground : Color.secondarySytemBackground.opacity(0.5))
      .cornerRadius(10)
      .overlay {
        if isSelected {
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color(.label), lineWidth: 2)
        }
      }
  }
}
