
import SwiftUI
import MarqueeText

struct ThreeWayPicker: View {
  @ObservedObject var model: ExercisesViewModel
  let collection: [Exercise]
  
  var body: some View { 
    HStack(spacing: 3) {
      GenericPicker(selectedItem: $model.selectedEquipment,
                    items: model.equipment(for: model.filter(collection)),
                    labelKeyPath: \.rawValue,
                    imageKeyPath: \.image,
                    placeholder: "Equipment")
      GenericPicker(selectedItem: $model.selectedMuscle,
                    items: model.muscles(for: model.filter(collection)),
                    labelKeyPath: \.displayName,
                    imageKeyPath: \.muscleGroupImage,
                    placeholder: "Muscle Group")
      GenericPicker(selectedItem: $model.selectedActivityType,
                    items: model.activities(for: model.filter(collection)),
                    labelKeyPath: \.rawValue,
                    imageKeyPath: \.hkType.sfSymbol,
                    placeholder: "Category")
    }
    .threeWayPickerStyle()
  }
}



// MARK: - GENERIC PICKER
struct GenericPicker<T: Hashable>: View {
  @Binding var selectedItem: T?
  let items: [T]
  let labelKeyPath: KeyPath<T, String>
  let imageKeyPath: KeyPath<T, String>
  let placeholder: String
  
  var body: some View {
    Menu {
      Section {
        clearFilter
      }
      
      Section {
        ForEach(items, id: \.self) { item in
          menuButton(for: item)
        }
      }
    } label: {
      label()
    }
  }
  
  
  @ViewBuilder // MARK: - MENU BUTTON
  fileprivate func menuButton(for item: T) -> some View {
    Button {
      selectedItem = item
    } label: {
      HStack {
        itemImage(item[keyPath: imageKeyPath], size: 10)
        Text(item[keyPath: labelKeyPath].capitalized)
      }
    }
  }
  
  
  @ViewBuilder // MARK: - LABEL
  private func label() -> some View {
    HStack(spacing: 5) {
      if let selectedItem {
        itemImage(selectedItem[keyPath: imageKeyPath],size: 20)
        
        MarqueeText(text: textForLabels(), font: .preferredFont(forTextStyle: .footnote), leftFade: 5, rightFade: 1, startDelay: 2)
          .foregroundColor(.primary)
      }
      else {
        Text(textForLabels())
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
      }
    }
    .labelForPickers(isSelected: selectedItem != nil)
  }
  
  private func textForLabels() -> String {
    selectedItem?[keyPath: labelKeyPath].capitalized ?? placeholder
  }
  
  @ViewBuilder // MARK: - IMAGE
  private func itemImage(_ text: String, size: CGFloat) -> some View {
    if isActivity() {
      Image(systemName: text)
        .resizable()
        .scaledToFit()
        .frame(width: size, height: size)
        .foregroundColor(.primary)
    }
    else {
      Image(text)
        .resizable()
        .scaledToFit()
        .frame(width: size, height: size)
        .colorMultiply(.primary)
    }
  }
  
  private func isActivity() -> Bool {
    let element = items[0]
    let type = type(of: element)
    return type == ActivityType.self
  }
  
  @ViewBuilder // MARK: - CLEAR FILTER
  private var clearFilter: some View {
    Button(role: .destructive) {
      selectedItem = nil
    } label: {
      HStack {
        Image(systemName: "arrow.counterclockwise")
        Text("Clear filter")
      }
    }
  }
}


extension View {
  func labelForPickers(isSelected: Bool) -> some View {
    self
      .bold()
      .multilineTextAlignment(.leading)
      .font(.footnote)
      .padding(.horizontal, 5)
      .frame(maxWidth: .infinity)
      .frame(height: 30)
      .cornerRadius(13)
      .overlay {
        if isSelected {
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.accentColor.gradient, lineWidth: 1)
        }
      }
  }
}
