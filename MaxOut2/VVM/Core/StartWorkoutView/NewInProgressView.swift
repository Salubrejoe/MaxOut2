
import SwiftUI

struct NewInProgressView: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  
  @ObservedObject var model: StartViewModel
  @State private var restTime = 40.0
  
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  var body: some View {
    ParallaxScrollView(background: Color.systemBackground, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 200) {
      LazyVGrid(columns: columns, spacing: 5) {
        ForEach($model.sessions) { $session in
          SessionView(session: $session, model: model)
        }
        LargeTsButton(text: "🦾 Add Exercises", buttonColor: Color.secondarySytemBackground, textColor: .accentColor) {
          model.isShowingPicker = true
        }
      }
      .padding(.vertical)
      .fullScreenCover(isPresented: $model.isShowingPicker) {
        fullScreenPicker
      }
      .animation(.spring(), value: model.sessions)
      .alert(model.alertText, isPresented: $model.showingCancelAlert) { finishAlert }
    } header: {
      header
    }
  }
}

extension NewInProgressView {
  
  @ViewBuilder
  private var header: some View {
    VStack {
      HStack {
        Button {
          model.showingCancelAlert = true
        } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.secondary)
        }
        Text(model.stateTextString())
          .font(.largeTitle.bold())
      }
      
      HStack {
        Spacer()
        TSTimerView(startDate: model.startDate) {
          model.saveTask()
        }
      }
    }
    .padding(.horizontal)
  }
  
  @ViewBuilder // MARK: - FULL SCREEN PICKER
  private var fullScreenPicker: some View {
    ZStack(alignment: .topLeading) {
      Button("Cancel") {
        model.isShowingPicker = false
      }
      ExercisePickerView(routineModel: model)
    }
  }
  
  @ViewBuilder // MARK: - CANCEL Alert
  private var finishAlert: some View {
    Button("Resume", role: .cancel) {}
    Button("Quit", role: .destructive) {
      model.cancelRoutine()
      model.showingCancelAlert = false
    }
  }
}
