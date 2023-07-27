
import SwiftUI


// MARK: - MGPICKER
struct MGPicker: View {
  @ObservedObject var model: ExercisesViewModel
  
  let muscles  : [Muscle] = Muscle.allCases
  
  var body: some View {
    Menu {
      Section {
        Button {
          model.selectedMuscle = nil
        } label: {
          Text("See All").bold()
        }
      }
      
      Section {
        ForEach(muscles, id: \.self) { muscle in
          Button {
            model.selectedMuscle = muscle
          } label: {
            HStack(spacing: 0) {
              Image(muscle.muscleGroupImage)
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .padding(2)
              Text(muscle.rawValue.capitalized)
            }
          }
        }
      }
    } label: {
      label(for: model.selectedMuscle)
    }
    .onChange(of: model.selectedMuscle) { newValue in
//      model.exercises = []
      model.addListenerToFavourites()
      print(model.exercises.count)
      if let muscle = newValue {
        model.exercises = model.exercises.filter { $0.muscle.rawValue == muscle.rawValue }
        print(model.exercises.count)
      }
    }
  }
  
  @ViewBuilder // MARK: - Label
  private func label(for selectedMuscle: Muscle?) -> some View {
    HStack(spacing: 0) {
      
      if let selectedMuscle {
        Image(selectedMuscle.muscleGroupImage)
          .resizable()
          .scaledToFit()
          .colorMultiply(selectedMuscle.color)
          .frame(width: 20, height: 20)
          .padding(.vertical, 7)
          
      }
      Text(selectedMuscle?.rawValue.capitalized ?? "Body Part")
        .foregroundStyle(selectedMuscle?.color.gradient ?? Color.secondary.gradient)
      
    }
    .foregroundStyle(model.selectedMuscle != nil ? Color.black.gradient : selectedMuscle?.color.gradient ?? Color.pink.gradient)
    .labelForPickers(background: model.selectedMuscle != nil ? (selectedMuscle?.color.gradient ?? Color.pink.gradient) : Color.secondarySytemBackground.gradient)
  }
}



// MARK: - APICKER
struct APicker: View {
  @ObservedObject var model: ExercisesViewModel
  
  let activityTypes : [ActivityType] = ActivityType.allCases
  
  var body: some View {
    Menu {
      Section {
        Button {
          model.selectedActivityType = nil
        } label: {
          Text("See All").bold()
        }
      }
      
      Section {
        ForEach(activityTypes, id: \.self) { type in
          Button {
            model.selectedActivityType = type
          } label: {
            Label(type.rawValue.capitalized, systemImage: type.logo)
          }
        }
      }
    } label: {
      label(for: model.selectedActivityType)
    }
  }
  
  @ViewBuilder // MARK: - Label
  private func label(for type: ActivityType?) -> some View {
    HStack(spacing: 5) {
      if let type {
        Image(systemName: type.logo)
          .frame(width: 20, height: 20)
      }
      Text(type?.hkType.commonName.capitalized ?? "Category")
    }
    
    .foregroundStyle(model.selectedActivityType != nil ? Color.black.gradient : Color.exerciseRing.gradient)
    .labelForPickers(background: model.selectedActivityType != nil ? Color.exerciseRing.gradient : Color.secondarySytemBackground.gradient)
  }
}


// MARK: - EQPICKER
struct EQPicker: View {
  @ObservedObject var model: ExercisesViewModel
  
  let equipmentTypes  : [EquipmentType] = EquipmentType.allCases
  
  var body: some View {
    Menu {
      Section {
        Button {
          model.selectedEquipment = nil
        } label: {
          Text("See All").bold()
        }
      }
      
      Section {
        ForEach(equipmentTypes, id: \.self) { eqType in
          Button {
            model.selectedEquipment = eqType
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
      label(for: model.selectedEquipment)
    }
  }
  
  @ViewBuilder // MARK: - Label
  private func label(for selectedEquipment: EquipmentType?) -> some View {
    HStack(spacing: 5) {
      if let selectedEquipment, selectedEquipment != .body {
        Image(selectedEquipment.image)
          .resizable()
          .scaledToFit()
          .colorMultiply(Color(.systemTeal))
          .frame(width: 20, height: 20)
      }
      Text(selectedEquipment?.rawValue.capitalized ?? "Equipment")
    }
    .foregroundStyle(model.selectedEquipment != nil ? Color.black.gradient : Color(.systemTeal).gradient)
    .labelForPickers(background: model.selectedEquipment != nil ? Color(.systemTeal).gradient : Color.secondarySytemBackground.gradient)
  }
}


extension View {
  func labelForPickers<Shape: ShapeStyle>(background: Shape) -> some View {
    self
      .padding(.horizontal, 7)
      .font(.footnote)
      .frame(maxWidth: 155)
      .frame(height: 37)
      .background(background)
      .clipShape(RoundedRectangle(cornerRadius: 7))
  }
}
