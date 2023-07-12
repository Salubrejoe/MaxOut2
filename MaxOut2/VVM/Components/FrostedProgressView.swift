import SwiftUI

struct FrostedProgressView: View {
  let text: String
  
  var body: some View {
    VStack {
      ProgressView()
        .frame(width: 50, height: 50)
        .imageScale(.large)
        .scaleEffect(2)
      
      Text(text)
        .multilineTextAlignment(.center)
    }
    .padding()
    .frame(width: 150, height: 150)
    .font(.headline)
    .foregroundColor(.secondary)
    .background(.ultraThinMaterial)
    .cornerRadius(20)
  }
}
