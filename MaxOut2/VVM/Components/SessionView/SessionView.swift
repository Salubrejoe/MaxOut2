
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
      HStack(alignment: .firstTextBaseline) {
        Image(systemName: session.activityType.hkType.sfSymbol)
        Text("\(session.exerciseName.capitalized)")
          .fontWeight(.semibold)
        Text(" -  \(session.timeString)").font(.caption2).foregroundColor(.gray)
        Spacer()
        
        menu
      }
      
      bobHeader
        .fontWeight(.semibold)
    }
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
  
  
  @ViewBuilder // MARK: - NEW BOB
  private var newBobButton: some View {
    HStack(spacing: 2) {
      Text("+ New Set")
    }
    .font(.footnote)
    .fontWeight(.semibold)
    .foregroundColor(.systemBackground)
    .frame(maxWidth: .infinity)
    .frame(height: 20)
    .background(.primary.opacity(0.1))
    .clipShape(RoundedRectangle(cornerRadius: 5))
    
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
  
  @ViewBuilder // MARK: - MENU
  private var menu: some View {
    Menu {
      Section {
        Button {
          //
        } label: {
          Label("Check How-To", systemImage: "list.bullet.clipboard")
        }
        Button {
          controller.open.send()
        } label: {
          Label("Mark All Completed", systemImage: "checkmark")
        }
      }
      Section {
        Button(role: .destructive) {
          removeAlert = true
        } label: {
          Label("Remove Execise", systemImage: "xmark")
        }
      }
    } label: {
      Image(systemName: "ellipsis.circle")
        .fontWeight(.semibold)
        .foregroundColor(.primary)
    }
  }
}


// MARK: - BOB HEADER
extension SessionView {
  @ViewBuilder
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
  
  @ViewBuilder // MARK: - STRENGTH
  private func strength(_ proxy: GeometryProxy) -> some View {
    let width = proxy.size.width
    HStack(spacing: 0) {
      Text("")
        .frame(width: width * 0.10)
        
      Text("KG")
        .frame(width: (width * 0.2))
        
      Text("REPS")
        .frame(width: (width * 0.20))
        
      Text("REST")
        .frame(width: width * 0.4)
        
      Text("")
        .frame(width: width * 0.10)
        
    }
  }
  
  
  @ViewBuilder // MARK: - STRETCHING
  private func cooldown(_ proxy: GeometryProxy) -> some View {
    let width = proxy.size.width
    HStack(spacing: 0) {
      Text("")
        .frame(width: width * 0.10)
        
      Text("LAST TIME")
        .frame(width: width * 0.35)
        
      Text("DURATION")
        .frame(width: width * 0.42)
      
      Text("")
        .frame(width: width * 0.10)
    }
  }
  
  @ViewBuilder // MARK: - CARDIO
  private func cardio(_ proxy: GeometryProxy) -> some View {
    let width = proxy.size.width
    HStack(spacing: 0) {
      Text("")
        .frame(width: width * 0.10)
        
      Text("LAST TIME")
        .frame(width: width * 0.25)
        
      Text("KM")
        .frame(width: (width * 0.20))
        
      Text("DURATION")
        .frame(width: (width * 0.35))
        
      Text("")
        .frame(width: width * 0.10)
        
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



