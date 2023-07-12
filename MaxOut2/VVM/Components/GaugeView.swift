import SwiftUI
import UserNotifications

final class GaugeViewController: ObservableObject {
  @Published var timer: Timer? = nil
  @Published var timeElapsed = 0.0
  @Published var isCounting = false
  @Published var startDate: Date? = nil
  let timerInterval = 0.05
  
  let gradient = LinearGradient(colors: [
    //    Color(.systemRed),
    //    Color(.systemOrange),
    Color.primary
//    Color.accentColor
  ], startPoint: .top, endPoint: .bottom)
  
  
  func requestNotificationPermish() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
      if success {
        print("All set!")
      } else if let error = error {
        print(error.localizedDescription)
      }
    }
  }
  
  func sendNotification(_ numberOfSeconds: Double) {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    let content = UNMutableNotificationContent()
    content.title = "Timer has expired"
    content.subtitle = "Back to it 🏋️‍♂️"
    content.sound = UNNotificationSound.default
    
    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: numberOfSeconds - timeElapsed, repeats: false)
    
    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    // add our notification request
    UNUserNotificationCenter.current().add(request)
  }
  
  func onTapAction(_ numberOfSeconds: Double) {
    if !isCounting {
      isCounting = true
      sendNotification(numberOfSeconds)
      startTimer(numberOfSeconds)
    }
    else {
      timer?.invalidate()
      isCounting = false
    }
  }
  
  func startTimer(_ numberOfSeconds: Double) {
    startDate = Date()
    
    timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] timer in
      guard let self else { return }
      
      self.timeElapsed += self.timerInterval
      if numberOfSeconds - self.timeElapsed < 0.1 {
        timer.invalidate()
        self.isCounting = false
        self.timeElapsed = 0
      }
    }
  }
  
  func resumeTimer(_ numberOfSeconds: Double) {
    guard let date = startDate else { return }
    let now = Date().timeIntervalSince1970
    timeElapsed = now - date.timeIntervalSince1970
    startTimer(numberOfSeconds)
  }
}


  
struct GaugeView: View {
  @StateObject private var model = GaugeViewController()
  @Binding var numberOfSeconds: Double
  
  @State private var isShowingSheet = false

  var body: some View {
    VStack(spacing: 3) {
      HStack {
        Button {
          model.onTapAction(numberOfSeconds)
        } label: {
          Image(systemName: "stopwatch")
          Text("\(Int(numberOfSeconds - model.timeElapsed))s")
        }
        .contextMenu {
          TimerSheet(value: $numberOfSeconds)
            .onChange(of: numberOfSeconds) { newValue in
              model.sendNotification(numberOfSeconds)
            }
        }
      }
      .font(.headline)
      .padding(.top, 6)
//      .padding(.horizontal, 16)
      .fontDesign(.rounded)
//      .foregroundStyle(model.gradient)
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
        model.timer?.invalidate()
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
        if model.isCounting {
          model.resumeTimer(numberOfSeconds)
        }
      }
      
      Gauge(value: numberOfSeconds - model.timeElapsed, in: 0...numberOfSeconds) {}
        .gaugeStyle(.accessoryLinearCapacity)
        .tint(.blue)
        .animation(.linear, value: model.timeElapsed)
    }
    .frame(minWidth: 80)
    .frame(height: 47)
    .foregroundColor(.blue)
//    .background(Color.secondarySytemBackground)
//    .cornerRadius(14)
  }
  

  private struct TimerSheet: View {
    @Binding var value: Double
    
    var body: some View {
      VStack {
        Slider(value: $value, in: 0...300)
        HStack {
          Button {
            value = 30
          } label: {
            Text("30s")
          }
          Button {
            value = 40
          } label: {
            Text("40s")
          }
        }
        
        HStack {
          Button {
            value = 50
          } label: {
            Text("50s")
          }
          Button {
            value = 60
          } label: {
            Text("60s")
          }
        }
        
        HStack {
          Button {
            value = 70
          } label: {
            Text("70s")
          }
          Button {
            value = 80
          } label: {
            Text("80s")
          }
        }
        
        HStack {
          Button {
            value = 90
          } label: {
            Text("90s")
          }
          Button {
            value = 100
          } label: {
            Text("100s")
          }
        }
      }
    }
  }
  
  private struct TimerStepper: View {
    @Binding var value: Double
    
    var body: some View {
      HStack {
        Button { value -= 1 } label: { Image(systemName: "minus") }
        Divider()
        Button { value += 1 } label: { Image(systemName: "plus") }
      }
      .font(.headline)
    }
  }
}

struct GaugeView_Previews: PreviewProvider {
  static var previews: some View {
//    CustomGauge(size: 10)
//      .previewContext(WidgetPreviewContext(family: .systemSmall))
    GaugeView(numberOfSeconds: .constant(20))
  }
}
