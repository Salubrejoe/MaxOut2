
import SwiftUI
import BottomSheet


struct SheetFun: View {
  
  @State var position = BottomSheetPosition.hidden
  
  var body: some View {
    Button(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/) {
      position = .dynamicBottom
    }
      .bottomSheet(bottomSheetPosition: $position,
                   switchablePositions: [.dynamicBottom, .absolute(425), .hidden],
                   headerContent: {
        VStack(alignment: .leading, spacing: 0) {
          Text("Pizza")
            .font(.largeTitle)
          Text("by Pizza")
            .foregroundColor(.secondary)
            .padding(.bottom, 3)
          
          Divider()
        }
        .padding()
      }) {
        Text("Pizza")
      }
      .enableBackgroundBlur()
  }
}

struct SheetFun_Previews: PreviewProvider {
  static var previews: some View {
    SheetFun()
  }
}
