import SwiftUI
import UIKit



struct TSTimerView: View {
  let startDate: Date
  let saveAction: () -> ()
  
  @State private var animationAmount = 1.0
  @State private var isShowingAlert = false
  
  var body: some View {
    Button {
      isShowingAlert = true
    } label: {
      ZStack {
        HStack {
          Text(startDate, style: .timer)
            .font(.headline)
            .foregroundColor(.primary)
//          Image(systemName: "record.circle")
//            .imageScale(.large)
//            .foregroundColor(.red)
          Spacer()
        }
        
        HStack {
          Spacer()
//          Text(startDate, style: .timer)
//            .font(.headline)
//            .foregroundColor(.primary)
          Image(systemName: "record.circle")
            .imageScale(.large)
            .foregroundColor(.red)
        }
      }
      
      .padding(.vertical, 3)
//      .frame(width: 90)
      .frame(minWidth: 80)
      .frame(height: 47)
      .padding(.leading, 13)
      .padding(.trailing, 11)
      .background(Color.cell)
      .cornerRadius(14)
      .alert("Sure you want to finish?", isPresented: $isShowingAlert) { finishAlert }
      
    }
  }
  @ViewBuilder // MARK: - FINISH Alert
  private var finishAlert: some View {
    Button("Resume", role: .cancel) {}
    Button("Finish") {
      saveAction()
      isShowingAlert = false
    }
  }
}


struct TSTimerView_Previews: PreviewProvider {
  static var previews: some View {
    TSTimerView(startDate: Date()) {}
  }
}



// MARK: - ANIMATION ViewModifier
//extension View {
//  func animateCircleAndScale(_ animationAmount: CGFloat) -> some View {
//    self
//      .scaleEffect(animationAmount) // Scale the image based on the isAnimating state
////      .animation(
////        .easeInOut(duration: 2.0)
////        .repeatForever(autoreverses: true),
////        value: animationAmount)
//      .overlay(
//        Circle()
//          .stroke(Color.evidenziatore)
////          .scaleEffect(animationAmount * 1.4)
////          .opacity(2 - animationAmount)
//          .blur(radius: 3)
////          .animation(
////            .easeInOut(duration: 2)
////            .repeatForever(autoreverses: true),
////            value: animationAmount
////          )
//      )
//  }
//}
