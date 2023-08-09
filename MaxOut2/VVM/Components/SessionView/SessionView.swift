
import SwiftUI
import Combine
import SwipeActions


struct SessionView: View {
  @Binding var session: Session
  @StateObject private var controller = SeshController()
  @EnvironmentObject var model: StartViewModel
  
  @State private var text = ""
  
  @State private var removeAlert = false

  var body: some View {
    SwipeViewGroup {
      VStack(spacing: 0) {
        VStack(spacing: 0) {
          
          header
          
          VStack(spacing: 0) {
            ForEach($session.bobs) { $bob in
              BobView(controller: controller, bob: $bob, session: $session)
//              TimeTextField(text: $bob.duration)
            }
          }
          .cornerRadius(10)
          .padding(.bottom, 5)
        }
        
        newBobButton
          .padding(.bottom, 20)
          .padding(.top, 5)
      }
      .textFieldClearButton
    }
  }
}



extension SessionView {
  @ViewBuilder // MARK: - HEADER
  private var header: some View {
    VStack(spacing: 6) {
      HStack {
        HStack {
          Button {
            model.remove(session)
          } label: {
            HStack(alignment: .firstTextBaseline) {
              Text("\(session.exerciseName.capitalized)")
                .fontWeight(.semibold)
              Text(" -  \(session.timeString)").font(.caption2).foregroundColor(.gray)
            }
          }
          Spacer()
        }
        .bold()
        .onTapGesture {
          removeAlert = true
        }
        
        
        Button {
          controller.open.send()
        } label: {
          Image(systemName: "checkmark")
            .font(.headline)
            .foregroundColor(controller.isCompleted(session) ? Color(.systemGreen) : .accentColor)
        }
      }
      
      bobHeader
    }
    .frame(maxWidth: 428)
    .alert("Remove?", isPresented: $removeAlert, actions: {
      Button("Cancel", role: .cancel) {}
      Button {
        model.remove(session)
        removeAlert = false
      } label: {
        Label("Remove", systemImage: "trash")
      }
    })
  }

  @ViewBuilder // MARK: - BOB HEADER
  private var bobHeader: some View {
    GeometryReader { proxy in
      
      if session.activityType == .traditionalStrengthTraining || session.activityType == .coreTraining {
        strength(proxy)
      }
      else if session.activityType == .flexibility {
        cooldown(proxy)
      }
      else {
        cardio(proxy)
      }
     
    }
    .frame(height: 15)
    .font(.caption2)
    .foregroundColor(.gray)
  }
  
  private func textForHeader() -> (String, String) {
    switch session.activityType {
      case .traditionalStrengthTraining, .coreTraining : return ("KG", "REPS")
      case .flexibility : return ("M", "S")
      default : return ("KM", "MIN")
    }
  }
  
  
  @ViewBuilder // MARK: - STRENGTH
  private func strength(_ proxy: GeometryProxy) -> some View {
    let width = proxy.size.width
    HStack(spacing: 0) {
      HStack {
        Spacer()
        Text(textForHeader().0)
          .padding(.trailing, 25)
      }
      .frame(width: (width * 0.305))
      
      HStack {
        Text(textForHeader().1)
          .padding(.leading, 22)
        Spacer()
      }
      .frame(width: (width * 0.20))
      
      
      Text("REST")
        .padding(.trailing, 20)
        .frame(width: width * 0.45)
    }
  }
  
  
  @ViewBuilder // MARK: - CARDIO
  private func cardio(_ proxy: GeometryProxy) -> some View {
    let width = proxy.size.width
    HStack(spacing: 0) {
      Text("LAST TIME")
        .padding(.trailing, 20)
        .frame(width: width * 0.45)
      
      HStack {
        Spacer()
        Text(textForHeader().0)
          .padding(.trailing, 25)
      }
      .frame(width: (width * 0.305))
      
      HStack {
        Text(textForHeader().1)
          .padding(.leading, 22)
        Spacer()
      }
      .frame(width: (width * 0.20))
    }
  }
  
  @ViewBuilder // MARK: - COOLDOWN
  private func cooldown(_ proxy: GeometryProxy) -> some View {
    let width = proxy.size.width
    HStack(spacing: 0) {
      Text("LAST TIME")
        .padding(.trailing, 20)
        .frame(width: width * 0.42)
      
      HStack {
        Spacer()
        Text("H")
          .padding(.trailing, 25)
      }
      .frame(width: (width * 0.2))
      
      HStack {
        Spacer()
        Text(textForHeader().0)
          .padding(.trailing, 25)
      }
      .frame(width: (width * 0.2))
      
      HStack {
        Text(textForHeader().1)
          .padding(.leading, 22)
        Spacer()
      }
      .frame(width: (width * 0.20))
    }
  }

  
  @ViewBuilder // MARK: - NEW BOB
  private var newBobButton: some View {
    HStack(spacing: 2) {
      Text("+ New Set")
    }
    .font(.headline)
    .foregroundColor(.primary)
    .frame(maxWidth: .infinity)
    .frame(height: 20)
    .background(.ultraThinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    
    .onTapGesture {
      if let lastBob = session.bobs.last {
        let bob = Bob(bob: lastBob)
        withAnimation(.easeIn) {
          session.bobs.append(bob)
        }
      } else {
        withAnimation(.easeIn) {
          session.bobs.append(Bob())
        }
      }
    }
  }
}


struct SessionView_Previews: PreviewProvider {
  static var previews: some View {
    SessionView(session: .constant(
      Session(id: "", exerciseId: "", exerciseName: "Bench Press", dateCreated: Date(), activityType: .traditionalStrengthTraining, bobs: [
        Bob(kg: "23", reps: "10", isCompleted: true, restTime: 45),
        Bob(kg: "23", reps: "10", isCompleted: true, restTime: 45),
        Bob(kg: "25", reps: "10", isCompleted: true, restTime: 45),
        Bob(kg: "27", reps: "9", isCompleted: false, restTime: 45)
      ], image: "figure.rower")
    ))
    .environmentObject(StartViewModel())
    .padding(.horizontal)
  }
}



