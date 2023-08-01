import SwiftUI
import UserNotifications

final class GaugeViewController: ObservableObject {
  @Published var timer: Timer? = nil
  @Published var timeElapsed = 0.0
  @Published var isCounting = false
  @Published var startDate: Date? = nil
  let timerInterval = 0.05
  
  let gradient = LinearGradient(colors: [.secondary, .secondary.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
  
  func requestNotificationPermish() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
     if let error = error {
        print(error.localizedDescription)
      }
    }
  }
  
  func sendNotification(_ numberOfSeconds: Double, identifier: String) {
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    let content = UNMutableNotificationContent()
    content.title = "Your \(numberOfSeconds)s timer has expired"
    content.subtitle = "Back to it 🏋️‍♂️"
    content.sound = UNNotificationSound.default
    

    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: numberOfSeconds - timeElapsed, repeats: false)
    
    // choose a random identifier
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    

    // add our notification request
    UNUserNotificationCenter.current().add(request)
  }
  
  func onTapAction(_ numberOfSeconds: Double, identifier: String) {
    if !isCounting {
      isCounting = true
      sendNotification(numberOfSeconds, identifier: identifier)
      print("Ontap -> notif sent")
      print("Going to start timer with \(numberOfSeconds) seconds")
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
      progressTime(with: timer, numberOfSeconds: numberOfSeconds)
    }
  }
  
  func resumeTimer(_ numberOfSeconds: Double) {
    guard let date = startDate else { return }
    let now = Date().timeIntervalSince1970
    timeElapsed = now - date.timeIntervalSince1970
    startTimer(numberOfSeconds)
  }
  
  func resetTimer(_ numberOfSeconds: Double) {
    timer?.invalidate()
    self.timeElapsed = 0
    startTimer(numberOfSeconds)
  }
   
  private func progressTime(with timer: Timer, numberOfSeconds: Double) {
    self.timeElapsed += self.timerInterval
    if numberOfSeconds - self.timeElapsed < 0.1 {
      timer.invalidate()
      self.isCounting = false
      self.timeElapsed = 0
    }
  }
}

struct BobGauge: View {
  @StateObject private var model = GaugeViewController()
  @Binding var bob: Bob
  
  @State private var isShowingSheet = false

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Button {
          model.onTapAction(bob.restTime, identifier: bob.id)
        } label: {
          Image(systemName: "stopwatch")
            .frame(width: 30, alignment: .trailing)
          Text("\(Int(bob.restTime - model.timeElapsed))s")
            .frame(width: 60, alignment: .leading)
        }
        
      }
      .font(.headline)
      .padding(.vertical, 2)
      .fontDesign(.rounded)
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
        model.timer?.invalidate()
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
        if model.isCounting {
          model.resumeTimer(bob.restTime)
        }
      }
      
      Gauge(value: bob.restTime - model.timeElapsed, in: 0...bob.restTime) {}
        .gaugeStyle(.accessoryLinearCapacity)
        .tint(.primary)
        .rotationEffect(.radians(.pi))
        .animation(.linear, value: model.timeElapsed)
    }
    .frame(minWidth: 80)
    .frame(height: 46)
//    .foregroundStyle(Color.accentColor)
    
    .contextMenu {
      TimerSheet(value: $bob.restTime, model: model)
        .onChange(of: bob.restTime) { newValue in
          if newValue < model.timeElapsed { model.resetTimer(bob.restTime) }
          model.sendNotification(bob.restTime, identifier: bob.id)
        }
    }
  }
  

  private struct TimerSheet: View {
    @Binding var value: Double
    @ObservedObject var model: GaugeViewController
    
    var body: some View {
      VStack {
        Slider(value: $value, in: 0...300)
        HStack {
          Button {
            value = 30
            model.resetTimer(value)
          } label: {
            Text("30s")
          }
          Button {
            value = 40
            model.resetTimer(value)
          } label: {
            Text("40s")
          }
        }
        
        HStack {
          Button {
            value = 50
            model.resetTimer(value)
          } label: {
            Text("50s")
          }
          Button {
            value = 60
            model.resetTimer(value)
          } label: {
            Text("60s")
          }
        }
        
        HStack {
          Button {
            value = 70
            model.resetTimer(value)
          } label: {
            Text("70s")
          }
          Button {
            value = 80
            model.resetTimer(value)
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
    BobGauge(bob: .constant(Bob(kg: "0", reps: "0", duration: 0, distance: "0", isCompleted: false, restTime: 50)))
  }
}
