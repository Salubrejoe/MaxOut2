
import SwiftUI
import Combine

struct InProgressHeader: View {
  @EnvironmentObject var model: StartViewModel
  @EnvironmentObject var manager: HealthKitManager
  @Binding var tabBarState: BarState
  
  var body: some View {
    VStack(alignment: .leading) {
      if tabBarState == .hidden {
        HStack {
          Button {
            model.showingCancelAlert = true
          } label: {
            Image(systemName: "xmark.circle.fill")
              .imageScale(.large)
              .symbolRenderingMode(.hierarchical)
              .foregroundColor(.red.opacity(0.8))
          }
          Spacer()
          Button("🤪 Finish") {
            manager.saveWorkout(start: model.startDate, end: Date(), activityType: model.activityType())
            model.inProgress = false
            model.congratulationsScreen = true
            tabBarState = .large
            model.saveTask()
          }
          .bold()
          .buttonStyle(.bordered)
          .foregroundColor(.accentColor)
        }
      }
      
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          Label(model.activityType().hkType.name, systemImage: model.activityType().hkType.sfSymbol)
            .font(model.position == .absoluteBottom(180) ? .title2.bold() : .title.bold())
            .minimumScaleFactor(0.7)
          Spacer()
          if tabBarState == .hidden {
            Image(systemName: "ellipsis.circle.fill")
              .imageScale(.large)
          }
        }
        HStack {
          Text(model.startDate, style: .timer)
          Spacer()
          Text(Date().formattedString())
        }
        .foregroundColor(.secondary)
        .fontWeight(.semibold)
      }
    }
    .padding(.horizontal)
    .padding(.bottom)
  }
}


struct SessionsGrid: View {
  @EnvironmentObject var model: StartViewModel
  @Binding var tabBarState: BarState
  
  @State private var keyboardHeight: CGFloat = 0


  var body: some View {
    ScrollViewReader { pageScroller in
      ScrollView(showsIndicators: false) {
        LazyVGrid(columns: model.largeColumns, spacing: 5) {
          if !model.sessions.isEmpty {
            ForEach($model.sessions) { $session in
              SessionView(session: $session)
                .id(session.id)
            }
          }
          
          MOButton(text: "Add Exercises", background: .primary, textColor: .systemBackground) {
            model.isShowingPicker = true
          }
          .padding(.top, 20)
          
          Spacer(minLength: 100)
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
      }
      .scrollDismissesKeyboard(.immediately)
      .fullScreenCover(isPresented: $model.isShowingPicker) { fullScreenPicker }
      .animation(.spring(), value: model.sessions)
      .alert(model.alertText, isPresented: $model.showingCancelAlert) { finishAlert }
      
//      .onReceive(model.inputViewPublisher) { height in
//      }
//      .padding(.bottom, keyboardHeight)
//      .edgesIgnoringSafeArea(keyboardHeight > 0 ? .bottom : [])
    }
  }
}

extension SessionsGrid {
  @ViewBuilder // MARK: - FULL SCREEN PICKER
  private var fullScreenPicker: some View {
    ZStack(alignment: .topLeading) {
      Button("Cancel") {
        model.isShowingPicker = false
      }
      ExercisesPicker(activityType: model.activityType())
    }
  }
  
  @ViewBuilder // MARK: - CANCEL Alert
  private var finishAlert: some View {
    Button("Resume", role: .cancel) {}
    Button("Quit", role: .destructive) {
      model.cancelRoutine()
      model.showingCancelAlert = false
      model.inProgress = false
      tabBarState = .large
    }
  }
}




//  private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
//    Publishers.Merge(
//      NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
//        .compactMap { notification -> CGFloat? in
//          guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
//            return nil
//          }
//          return keyboardFrame.height
//        },
//      NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
//        .map { _ in CGFloat(0) }
//    ).eraseToAnyPublisher()
//  }
