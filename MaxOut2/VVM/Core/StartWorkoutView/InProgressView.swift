import SwiftUI


struct InProgressView: View {
  @ObservedObject var model: StartViewModel
  @State private var restTime = 40.0
  @State private var isShowingKeyboard = false
  
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  var body: some View {
        LazyVGrid(columns: columns, spacing: 5) {
          ForEach($model.sessions) { $session in
            SessionView(session: $session, model: model)
          }
          
          VStack {
            LargeTsButton(text: "🦾 Add Exercises", buttonColor: Color.secondarySytemBackground, textColor: .accentColor) {
              model.isShowingPicker = true
            }
            LargeTsButton(text: "Cancel Workout", buttonColor: .clear, textColor: Color(.systemRed)) {
              model.showingCancelAlert = true
            }
          }
          .padding(.top, 25)
        }
        .navigationTitle(model.stateTextString())
        .fullScreenCover(isPresented: $model.isShowingPicker) { fullScreenPicker }
        .toolbar { timer }
        .animation(.spring(), value: model.sessions)
        .alert(model.alertText, isPresented: $model.showingCancelAlert) { cancelAlert }
  }
}

extension InProgressView {
  
  @ViewBuilder // MARK: - FULL SCREEN PICKER
  private var fullScreenPicker: some View {
    ZStack(alignment: .topLeading) {
      Button("Cancel") {
        model.isShowingPicker = false
      }
      ExercisePickerView(routineModel: model)
//      LesPickerView(sharedModel: model, isDiscovering: false)
    }
  }
  
  @ToolbarContentBuilder // MARK: - TOOLBAR
  private var timer: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      GaugeView(numberOfSeconds: $restTime)
    }
    
    ToolbarItem(placement: .navigationBarTrailing) {
      TSTimerView(startDate: model.startDate) {
        model.saveTask()
      }
    }
  }
  
  @ViewBuilder // MARK: - CANCEL Alert
  private var cancelAlert: some View {
    Button("Resume", role: .cancel) {}
    Button("Quit", role: .destructive) {
      model.cancelRoutine()
      model.showingCancelAlert = false
    }
  }
}
