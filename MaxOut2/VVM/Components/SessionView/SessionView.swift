
import SwiftUI
import Combine
import SwipeActions


struct SessionView: View {
  @Binding var session: Session
  @StateObject private var controller = SessionViewModel()
  @ObservedObject var model: StartViewModel
  
  @State private var removeAlert = false

  var body: some View {
    SwipeViewGroup {
      VStack {
        VStack(alignment: .set, spacing: 0) {
          
          header
            .padding(.horizontal, 16)
            .padding(.top, 15)
          
          VStack(spacing: 0) {
            
            ForEach($session.bobs.indices, id: \.self) { index in
              BobView(model: controller, session: $session,  index: index)
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
      .task { try? await controller.equipment(for: session) }
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
          Image(systemName: "checkmark")
            .imageScale(.medium)
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
        Text("SET")
          .frame(width: width * 0.1)
        Text(controller.equipment?.uppercased() ?? "")
          .frame(width: width * 0.4)
        Text("KG")
          .frame(width: width * 0.20)
        Text("REPS")
          .frame(width: width * 0.25)
      }
    }
    .frame(height: 15)
    .font(.caption)
    .foregroundColor(.secondary)
    .shadow(color: .gray.opacity(0.5), radius: 1)
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
       Image(systemName: "plus")
          .bold()
          .imageScale(.medium)
          .foregroundStyle(Color.primary.gradient.shadow(.inner(color: .accentColor.opacity(0.9), radius: 1)))
      }
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 3)
    .background(.ultraThinMaterial)
    .clipShape(Capsule())
    .shadow(radius: 1)
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
