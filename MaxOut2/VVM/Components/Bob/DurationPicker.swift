import SwiftUI

struct DurationPicker: View {
  @Binding var hh: Int
  @Binding var mm: Int
  @Binding var ss: Int
  
  @State private var isShowingPicker = false
  @State private var includeHours = false
  
  var body: some View {
    VStack {
      label
        .sheet(isPresented: $isShowingPicker) {
          pickerView
            .presentationDetents([.fraction(0.4)])
            .dismissButton()
            .animation(.spring(), value: includeHours)
        }
    }
    .fontWeight(.semibold)
  }
  
  @ViewBuilder // MARK: - LABEL
  private var label: some View {
    Button {
      isShowingPicker.toggle()
    } label: {
      HStack(spacing: 0) {
        if includeHours {
          Text("\(String(format: "%02d", hh)):")
        }
        Text("\(String(format: "%02d", mm)):")
        Text("\(String(format: "%02d", ss))")
      }
    }
    .foregroundColor(isShowingPicker ? .secondary : .primary)
  }
}


// MARK: - PICKER VIEW
extension DurationPicker {
  
  @ViewBuilder   private var pickerView: some View {
    ZStack {
      Color(uiColor: UIColor.secondarySystemBackground).ignoresSafeArea()
      
      VStack {
        HStack {
          XMark()
          
          Spacer()
        }
        
        wheels
        hhMmSsLabel
        
        includeHoursButton
        doneButton
      }
      .padding()
    }
  }
  
  
  @ViewBuilder
  private var wheels: some View {
    HStack {
      if includeHours {
        Picker("", selection: $hh) {
          correctTextFor(from: 0, to: 24)
        }
        Text(":")
      }
      Picker("", selection: $mm) {
        correctTextFor(from: 0, to: 60)
      }
      Text(":")
      Picker("", selection: $ss) {
        correctTextFor(from: 0, to: 60)
      }
    }
    .pickerStyle(.wheel)
  }
  
  @ViewBuilder
  private func correctTextFor(from number: Int, to range: Int) -> some View {
    ForEach(number..<range, id: \.self) { i in
      if i < 10 {
        Text("0\(i)")
      }
      else {
        Text("\(i)")
      }
    }
  }
  
  @ViewBuilder
  private var hhMmSsLabel: some View {
    HStack {
      if includeHours {
        Text("hh")
          .frame(maxWidth: .infinity)
      }
      
      Text("mm")
        .frame(maxWidth: .infinity)

      Text("ss")
        .frame(maxWidth: .infinity)

    }
  }
  
  @ViewBuilder
  private var includeHoursButton: some View {
    Button("Include Hours") {
      includeHours.toggle()
    }
    .foregroundColor(.primary)
    .frame(maxWidth: .infinity, maxHeight: 30)
    .background(.ultraThinMaterial)
    .cornerRadius(10)
    .padding(.top)
  }
  
  @ViewBuilder
  private var doneButton: some View {
    Button("Done") {
      isShowingPicker = false
    }
    .foregroundColor(.white)
    .frame(maxWidth: .infinity, maxHeight: 30)
    .background(Color.accentColor)
    .cornerRadius(10)
    .padding(.bottom)
  }
}





// MARK: - Preview
struct DurationPicker_Previews: PreviewProvider {
  static var previews: some View {
    DurationPicker(hh: .constant(0), mm: .constant(12), ss: .constant(34))
  }
}
