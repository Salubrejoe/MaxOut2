
import SwiftUI


struct SignInWithGoogleButton: View {
  let action: () -> ()
  var body: some View {
    Button {
      action()
    } label: { googleLabel }
      .padding()
      .frame(maxWidth: 432)
      .frame(height: 46)
      .background(.red)
      .cornerRadius(10)
  }
  /// Google Label
  private var googleLabel: some View {
    HStack{
      Image("googleLogo")
        .resizable()
        .scaledToFit()
        .padding([.top, .bottom], 17)
      
      Text("Sign in with Google")
    }
    .font(.system(size: 18))
    .fontWeight(.semibold)
    .background(.red)
    .foregroundColor(.white)
    .frame(maxWidth: 432)
    .frame(height: 46)
  }
}


