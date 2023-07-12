import SwiftUI

struct LetterPicker: View {
  @Binding var selectedLetter: String
  let alphabet: [String]

  var body: some View {
    HStack {
      Spacer()
      asWheel
      }
    }
  
  @ViewBuilder
  private var asWheel: some View {
    Picker("", selection: $selectedLetter) {
      letterText
    }
    .pickerStyle(.wheel)
    .frame(width: 40, height: 200)
    .background(
      LinearGradient(colors: [
        .clear,
//        .systemBackground,
        .clear
      ], startPoint: .top, endPoint: .bottom)
    )
    .cornerRadius(20)
  }
  
  @ViewBuilder
  private var letterText: some View {
    ForEach(alphabet, id: \.self) {
      Text($0)
        .font(.headline)
        .foregroundColor(.primary)
    }
  }
}

