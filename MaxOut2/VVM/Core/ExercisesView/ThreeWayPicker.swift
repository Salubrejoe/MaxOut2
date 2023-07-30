
import SwiftUI


struct ThreeWayPicker: View {
  @ObservedObject var model: ExercisesViewModel
  
  var body: some View {
    HStack(spacing: 3) {
      EQPicker(selectedEquipment: $model.selectedEquipment)
      Divider()
        .padding(.vertical)
      MGPicker(selectedMuscle: $model.selectedMuscle)
      Divider()
        .padding(.vertical)
      APicker(selectedActivityType: $model.selectedActivityType)
    }
    .frame(maxHeight: 50)
    .padding(.horizontal, 7)
    .background(.ultraThinMaterial)
    .cornerRadius(10)
    .padding()
  }
}


// MARK: - MGPICKER
struct MGPicker: View {
  @Binding var selectedMuscle: Muscle?
  
  let muscles  : [Muscle] = Muscle.allCases
  
  var body: some View {
    Menu {
      Section {
        Button(role: .destructive) {
          selectedMuscle = nil
        } label: {
          HStack {
            Image(systemName: "arrow.counterclockwise")
            Text("Clear filter")
          }
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
                .colorMultiply(.primary)
                .frame(width: 10, height: 10)
              Text(muscle.displayName)
                
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
      Text(selectedMuscle?.displayName ?? "Select Muscle Group")
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
        Button(role: .destructive) {
          selectedActivityType = nil
        } label: {
          HStack {
            Image(systemName: "arrow.counterclockwise")
            Text("Clear filter")
          }
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
      Text(selectedActivityType?.hkType.commonName.capitalized ?? "Select Category")
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
        Button(role: .destructive) {
          selectedEquipment = nil
        } label: {
          HStack {
            Image(systemName: "arrow.counterclockwise")
            Text("Clear filter")
          }
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
      .padding(.horizontal, 7)
      .multilineTextAlignment(.leading)
      .font(.footnote)
      .frame(maxWidth: .infinity)
      .frame(height: 50)
//      .background(isSelected ? Color.systemBackground : Color.secondarySytemBackground.opacity(0.5))
      
      .cornerRadius(10)
      .overlay {
        if isSelected {
          RoundedRectangle(cornerRadius: 7)
            .stroke(Color(.label), lineWidth: 1)
        }
      }
  }
}
