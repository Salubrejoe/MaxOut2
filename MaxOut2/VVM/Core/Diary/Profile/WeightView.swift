import SwiftUI

struct WeightView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var manager: HealthKitManager
  @State private var weight = "0"
  
  var body: some View {
    ZStack(alignment: .bottom) {
      textField
      
      LargeTsButton(text: "Save", background: Color.accentColor, textColor: .systemBackground) {
        saveToHK()
        dismiss()
      }
      .padding([.horizontal, .bottom])
    }
    .toolbar { resignKeyboard }
    .onAppear {
      getHKWeight()
    }
  }
  
  private func saveToHK() {
    guard let weight = Double(weight) else { return }
    
    manager.submit(weight: weight)
  }
  
  private func getHKWeight() {
    
    guard let weight = manager.bodyMassStats.last else { return }
    
    self.weight = weight.weightString
  }
  
  @ViewBuilder
  private var textField: some View {
    GeometryReader { proxy in
      let width = proxy.size.width
      let height = proxy.size.height
      
      ScrollView(showsIndicators: false) {
        HStack {
          minusButton
            .frame(width: width/6)
          TextField("", text: $weight)
            .numbersOnly($weight)
            .multilineTextAlignment(.trailing)
            .frame(width: width/3)
          Text("Kg")
            .font(.title)
            .foregroundColor(.secondary)
          Spacer()
          plusButton
            .frame(width: width/6)
        }
        .font(.largeTitle)
        .frame(height: height)
      }
    }
  }
  
  @ViewBuilder
  private var plusButton: some View {
    Button {
      weight = weight.increment() ?? weight
    } label: {
      Image(systemName: "plus.circle.fill")
    }
  }
  
  @ViewBuilder
  private var minusButton: some View {
    Button {
      weight = weight.decrement() ?? weight
    } label: {
      Image(systemName: "minus.circle.fill")
    }
  }
  
  @ToolbarContentBuilder
  private var resignKeyboard: some ToolbarContent {
    ToolbarItem(placement: .keyboard) { Spacer() }
    ToolbarItem(placement: .keyboard) { ResignKeyboardButton() }
  }
}

struct WeightView_Previews: PreviewProvider {
  static var previews: some View {
    WeightView().environmentObject(HealthKitManager())
  }
}

struct HeightView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var manager: HealthKitManager
  @State private var height = "0"
  
  var body: some View {
    ZStack(alignment: .bottom) {
      textField
      
      LargeTsButton(text: "Save", background: Color.accentColor, textColor: .systemBackground) {
        saveToHK()
        dismiss()
      }
      .padding([.horizontal, .bottom])
    }
    .toolbar { resignKeyboard }
    .onAppear {
      getHKWeight()
    }
  }
  
  private func saveToHK() {
    guard let height = Double(height) else { return }
    
    manager.submit(height: height)
  }
  
  private func getHKWeight() {
    
    guard let height = manager.heightStats.last else { return }
    
    self.height = height.heightString
  }
  
  @ViewBuilder
  private var textField: some View {
    GeometryReader { proxy in
      let width = proxy.size.width
      let height = proxy.size.height
      
      ScrollView(showsIndicators: false) {
        HStack {
          minusButton
            .frame(width: width/6)
          TextField("", text: $height)
            .numbersOnly($height)
            .multilineTextAlignment(.trailing)
            .frame(width: width/3)
          Text("m")
            .font(.title)
            .foregroundColor(.secondary)
          Spacer()
          plusButton
            .frame(width: width/6)
        }
        .font(.largeTitle)
        .frame(height: height)
      }
    }
  }
  
  @ViewBuilder
  private var plusButton: some View {
    Button {
      height = height.increment() ?? height
    } label: {
      Image(systemName: "plus.circle.fill")
    }
  }
  
  @ViewBuilder
  private var minusButton: some View {
    Button {
      height = height.decrement() ?? height
    } label: {
      Image(systemName: "minus.circle.fill")
    }
  }
  
  @ToolbarContentBuilder
  private var resignKeyboard: some ToolbarContent {
    ToolbarItem(placement: .keyboard) { Spacer() }
    ToolbarItem(placement: .keyboard) { ResignKeyboardButton() }
  }
}


// MARK: - INCREMENT STRING
extension String {
  func increment() -> String? {
    guard var number = Double(self) else {
      return nil
    }
    number += 0.1
    return String(format: "%.1f", number)
  }
  
  func decrement() -> String? {
    guard var number = Double(self) else {
      return nil
    }
    number -= 0.1
    return String(format: "%.1f", number)
  }
}

