
import SwiftUI
import Combine
import SwipeActions

final class SessionViewModel: ObservableObject {
  /// Swipe action
  @Published var open = PassthroughSubject<Void, Never>()
  
  var isAllCompletedChekmarkFilled = true
  
  let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
  
  func toggleIsComplete(_ session: inout Session, index: Int) {
    if !isAllCompletedChekmarkFilled {
      session.bobs[index].isCompleted = true
      impactFeedback.impactOccurred()
      
    }
    else {
      session.bobs[index].isCompleted = false
    }
  }
}


struct SessionView: View {

  @Binding var isShowingKeyboard: Bool
  @Binding var session: Session
  @StateObject private var sessModel = SessionViewModel()
  @ObservedObject var model: StartViewModel
  
  @State private var removeAlert = false

  
  var body: some View {
    SwipeViewGroup {
      VStack {
        VStack(spacing: 5) {
          
          header
            .padding(.horizontal, 16)
            .padding(.top, 20)
          
          VStack(spacing: 0) {
            ForEach($session.bobs.indices, id: \.self) { index in
              BobView(model: sessModel, session: $session, isShowingKeyboard: $isShowingKeyboard, index: index)
            }
          }
          .background(Color.background)
          .cornerRadius(10)
          
          .padding(.bottom, 5)
        }
//        .background(Color.secondarySytemBackground)
        .cornerRadius(14)
        
        newSetButton
      }
    }
  }
}



extension SessionView {
  @ViewBuilder // MARK: - HEADER
  private var header: some View {
    VStack {
      HStack {
        HStack {
          Button {
            removeAlert = true
          } label: {
            Image(systemName: "xmark").imageScale(.small).foregroundColor(.secondary)
          }

          
          Text(session.exerciseName.capitalized)
            .fontDesign(.rounded)
          
          Image(session.image)
            .resizable().scaledToFit()
            .frame(width: 18, height: 18).foregroundColor(.secondary.opacity(0.5))
          Text(" - \(session.timeString)")
            .font(.caption)
            .foregroundColor(.secondary.opacity(0.5))
          
          Spacer()
        }
        .onTapGesture {
          removeAlert = true
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
        
        Button {
          sessModel.isAllCompletedChekmarkFilled.toggle()
          sessModel.open.send()
        } label: {
          Image(systemName: "checkmark")
            
//            .padding(.trailing, 4)
            .imageScale(.medium)
            .foregroundColor(!sessModel.isAllCompletedChekmarkFilled ? Color(.systemGreen) : .secondary)
        }
      }
      
    }
    .frame(maxWidth: 428)
    .bold()
  }

  
  @ViewBuilder // MARK: FOOTER
  private var newSetButton: some View {
    HStack {
      
      Button {
        if let lastBob = session.bobs.last {
          let bob = Bob(bob: lastBob)
          withAnimation {
            session.bobs.append(bob)
          }
        } else {
          withAnimation {
            session.bobs.append(Bob())
          }
        }
      } label: {
        Label("New Set", systemImage: "plus")
          .foregroundColor(.primary)
          .font(.subheadline)
      }
    }
  }
}





//struct SessionView_Previews: PreviewProvider {
//  static var previews: some View {
//    SessionView(isShowingKeyboard: .constant(true), session: .constant(Session(id: "Pizza",
//                                           exerciseId: "Margherita",
//                                           exerciseName: "Chest Fly",
//                                           dateCreated: Date(),
//                                           category: "strenght",
//                                           bobs: [
//                                            Bob(kg: 21.3, reps: 10),
//                                            Bob(kg: 21.3, reps: 10),
//                                            Bob(kg: 21.3, reps: 10),
//                                            Bob(kg: 21.3, reps: 10),
//                                            Bob(kg: 21.3, reps: 10)
//                                           ],
//                                           image: "trash"
//                                          )), sharedModel: StartViewModel()
//    )
//    
//  }
//}
