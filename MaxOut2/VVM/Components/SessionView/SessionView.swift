
import SwiftUI
import Combine
import SwipeActions


struct SessionView: View {
  @Binding var session: Session
  @StateObject private var controller = SeshController()
  @ObservedObject var model: StartViewModel
  
  @State private var removeAlert = false

  var body: some View {
    SwipeViewGroup {
      VStack(spacing: 1) {
        VStack(alignment: .set, spacing: 0) {
          
          header
            .padding(.horizontal, 16)
            .padding(.top, 15)
          
          VStack(spacing: 0) {
            
            ForEach($session.bobs) { $bob in
              BobView(controller: controller, bob: $bob, session: $session)
              
            }
          }
          .cornerRadius(10)
          .padding(.bottom, 5)
          .padding(.horizontal, 5)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        
        newSetButton
          .padding(.bottom, 20)
          .padding(.top, 2)
      }
      .onAppear {
        UITextField.appearance().clearButtonMode = .whileEditing
      }
    }
  }
}



extension SessionView {
  @ViewBuilder // MARK: - HEADER
  private var header: some View {
    VStack(spacing: 10) {
      HStack {
        HStack {
          Button {
            model.remove(session)
          } label: {
            HStack(alignment: .firstTextBaseline) {
              Label("\(session.exerciseName.capitalized)", systemImage: "ellipsis.circle")
              Text(" - \(session.timeString)").font(.caption2).foregroundColor(.secondary)
            }
          }
          Spacer()
        }
        .bold()
        .onTapGesture {
          removeAlert = true
        }
        
        
        Button {
          controller.isAllCompletedChekmarkFilled.toggle()
          controller.open.send()
        } label: {
          Image(systemName: "checkmark.circle")
            .imageScale(.medium)
            .bold()
            .foregroundColor(!controller.isAllCompletedChekmarkFilled ? Color(.systemGreen) : .secondary)
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
      let width = proxy.size.width
      HStack(spacing: 0) {
        Text("#")
          .frame(width: width * 0.1)
        
        Text(textForHeader().0)
          .frame(width: session.category != "stretching" ? (width * 0.20) : (width * 0.43))
        Text(textForHeader().1)
          .frame(width: session.category != "stretching" ? (width * 0.25) : 0)
        
        Text("REST TIME")
          .frame(width: width * 0.4)
      }
    }
    .frame(height: 15)
    .font(.caption)
    .foregroundColor(.secondary)
  }
  
  private func textForHeader() -> (String, String) {
    switch session.category {
      case "cardio": return ("KM", "MIN")
      case "stretching": return ("MIN", "")
      case "strength": return ("KG", "REPS")
      default: return ("","")
    }
  }
  
  @ViewBuilder // MARK: FOOTER
  private var newSetButton: some View {
    Image(systemName: "plus")
      .imageScale(.large)
      .foregroundColor(.primary.opacity(0.5))
      .padding(.vertical)
      .frame(maxWidth: 428)
      .frame(height: 27)
      .background(.ultraThinMaterial)
      .clipShape(Capsule())
      .overlay {
        Rectangle().fill(Color.secondarySytemBackground.opacity(0.01))
          .frame(maxWidth: .infinity)
          .frame(maxHeight: .infinity)
          .onTapGesture {
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
          }
    }
  }
}


extension HorizontalAlignment {
  enum PaulHudsonStruct: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[.leading]
    }
  }
  
  static let equipment = HorizontalAlignment(PaulHudsonStruct.self)
  static let set = HorizontalAlignment(PaulHudsonStruct.self)
}
