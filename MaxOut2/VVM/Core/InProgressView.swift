
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
          Button("Quit") {
            model.showingCancelAlert = true
          }
          .imageScale(.large)
          .foregroundColor(.secondary)
          .frame(width: 80, alignment: .leading)
          
          Text(Date().formattedString())
            .frame(maxWidth: .infinity)
            .fontWeight(.semibold)
          
          Button("Finish") {
            model.inProgress = false
            tabBarState = .large
//            model.saveTask()
//            manager.saveWorkout()
          }
          .bold()
          .frame(width: 80, alignment: .trailing)
          .buttonStyle(.bordered)
          .foregroundColor(.green)
        }
      }
      
      VStack(alignment: .leading) {
        HStack(alignment: .firstTextBaseline) {
          Text(model.routine?.title ?? "")
            .font(model.position == .absoluteBottom(180) ? .title2.bold() : .largeTitle.bold())
          Spacer()
          Image(systemName: "ellipsis.rectangle.fill")
            .imageScale(.large)
        }
        
        Text(model.startDate, style: .timer)
          .font(.headline)
          .foregroundColor(.secondary)
      }
    }
    .padding(.horizontal)
  }
}

struct SessionsGrid: View {
  @EnvironmentObject var model: StartViewModel
  @Binding var tabBarState: BarState
  
  @State private var keyboardHeight: CGFloat = 0
  private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
    Publishers.Merge(
      NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap { notification -> CGFloat? in
          guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return nil
          }
          return keyboardFrame.height
        },
      NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat(0) }
    ).eraseToAnyPublisher()
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        sessionGrid
          .padding(.horizontal)
          .padding(.vertical, 20)
      }
      
    }
    .scrollDismissesKeyboard(.interactively)
    .fullScreenCover(isPresented: $model.isShowingPicker) { fullScreenPicker }
    .animation(.spring(), value: model.sessions)
    .alert(model.alertText, isPresented: $model.showingCancelAlert) { finishAlert }
    .toolbar {
      ToolbarItem(placement: .keyboard) { Spacer() }
      ToolbarItem(placement: .keyboard) { ResignKeyboardButton() }
    }
    
    .onReceive(keyboardHeightPublisher) { height in
      withAnimation {
        keyboardHeight = height
      }
    }
    .padding(.bottom, keyboardHeight)
    .edgesIgnoringSafeArea(keyboardHeight > 0 ? .bottom : [])
  }
}

extension SessionsGrid {
  @ViewBuilder
  private var sessionGrid: some View {
    LazyVGrid(columns: model.largeColumns, spacing: 5) {
      ForEach($model.sessions) { $session in
        SessionView(session: $session, model: model)
      }
      
      LargeTsButton(text: "Add Exercises", background: .ultraThinMaterial, textColor: .accentColor, image: "exercisesList") {
        model.isShowingPicker = true
      }
      .padding(.top, 20)
      
      Spacer(minLength: 100)
    }
  }
  
  @ViewBuilder // MARK: - FULL SCREEN PICKER
  private var fullScreenPicker: some View {
    ZStack(alignment: .topLeading) {
      Button("Cancel") {
        model.isShowingPicker = false
      }
      ExercisesPicker()
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
