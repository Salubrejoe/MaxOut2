
import SwiftUI

struct GridHeader: View {
  let text = "Title"
  
  var body: some View {
    VStack(spacing: 5) {
      HStack {
        Text(text)
        Spacer()
        Button {
          //
        } label: {
          Text("+")
        }
      }
      Rectangle()
        .frame(height: 1)
    }
    .font(.title)
    .foregroundColor(.secondary)
    .frame(maxWidth: .infinity)
  }
}

struct GridHeader_Previews: PreviewProvider {
  static var previews: some View {
    GridHeader()
  }
}
