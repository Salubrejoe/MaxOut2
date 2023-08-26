import SwiftUI
import HealthKit
import MarqueeText

struct WidgetGrid: View {
  @EnvironmentObject var manager: HealthKitManager
  @StateObject var historyModel = HistoryViewModel()
  
  
  @State private var isShowingHistory      = false
  @State private var isShowingExerciseTime = false
  
  @Binding var tabBarState: BarState
  
  var body: some View {
      VStack(spacing: 20) {
        
        calendarGrid
        longWidgets
        activities
        
        ChartGrid()
        
        Spacer(minLength: 80)
      }
      .padding(.horizontal)
  }
  
  
  @ViewBuilder
  private var calendarGrid: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
      CalendarWidget()
        
        .environmentObject(historyModel)
        .onTapGesture { isShowingHistory = true }
        .sheet(isPresented: $isShowingHistory) {
          HistoryView()
            .environmentObject(historyModel)
        }
    }
  }
  
  @ViewBuilder
  private var longWidgets: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 307))]) {

        MediumCardView("Active Calories", color: .moveRing) {
          RingWidget(ring: .move)
        }
        MediumCardView("Exercise Minutes", color: .exerciseRing) {
          RingWidget(ring: .exercise)
        }
        MediumCardView("Stand Hours", color: .standRing) {
          RingWidget(ring: .stand)
        }
      
      .environmentObject(manager)
      .onTapGesture { isShowingExerciseTime = true }
      .sheet(isPresented: $isShowingExerciseTime) {
//        ExerciseTimeView()
        ActivitiesList()
          .environmentObject(manager)
          .presentationDetents([.large, .medium])
      }
      
      MediumCardView("Body Mass", color: .primary, style: RegularMaterialStyle()) {
        NavigationLink {
          WeightView(tabBarState: $tabBarState)
        } label: {
          BodyMassChart()
            .environmentObject(manager)
        }
      }
    }
  }
  
  @ViewBuilder //
  private var activities: some View {
    if !manager.currentActivities.isEmpty {
      let mappedActs  = manager.currentActivities.sorted { $0.duration > $1.duration}
      LazyVStack {
        ForEach(mappedActs) {
          SmallCardView(activity: $0, style: RegularMaterialStyle(), text: manager.timeRange.stringForWidget)
        }
      }
    }
  }
}

struct WidgetGrid_Previews: PreviewProvider {
  static var previews: some View {
    WidgetGrid(tabBarState: .constant(.hidden))
  }
}


// MARK: - CARD VIEW
struct MediumCardView<Content: View, Style: GroupBoxStyle>: View {
  
  let text: String
  let link: String?
  let color: Color
  let style: Style
  let content: () -> Content

  init(_ text: String, link: String? = nil, color: Color, style: Style = RegularMaterialStyle(), content: @escaping () -> Content) {
    self.text = text
    self.link = link
    self.color = color
    self.style = style
    self.content = content
  }
  
  var body: some View {
      ZStack(alignment: .topLeading) {
        Text(text)
          .fontWeight(.semibold)
          .foregroundColor(color)
        content()
          
      }
      .padding(.leading, 4)
  }
}

// MARK: - SMALL CARD VIEW
struct SmallCardView<Style: GroupBoxStyle>: View {
  
  let activity: Activity
  let style: Style
  let text: String
  
  var body: some View {
    HStack(alignment: .center) {
      MarqueeText(text: activity.name.capitalized, font: UIFont.preferredFont(forTextStyle: .footnote), leftFade: 5, rightFade: 5, startDelay: 2)
      
      Spacer()
      
      HhMmView(hour: activity.durationString.hour, minute: activity.durationString.minute)
      
      Image(systemName: activity.type.sfSymbol)
        .imageScale(.large)
        .frame(width: 30)
        .foregroundStyle(Color.exerciseRing.gradient)
    }
  }
}

struct RegularMaterialStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.content
      .padding(.horizontal, 17)
      .padding(.vertical, 14)
      .background(Color.systemBackground)
      .cornerRadius(20)
  }
}

struct SecondaryBackgroundStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.content
      .padding([.horizontal, .top])
      .padding(.bottom, 10)
      .background(Color.secondarySytemBackground)
      .cornerRadius(20)
  }
}

struct HhMmView: View {
  let hour: String
  let minute: String
  
  var body: some View {
    HStack(alignment: .bottom) {
      if hour != "" {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          Text(hour)
            .font(.title2)
            .foregroundStyle(Color.primary.gradient)
          Text("h")
            .font(.title3)
            .foregroundStyle(Color.secondary.gradient)
        }
      }
      if minute != "00" {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          Text(minute)
            .font(.title2)
            .foregroundStyle(Color.primary.gradient)
          Text("m")
            .font(.title3)
            .foregroundStyle(Color.secondary.gradient)
        }
        .frame(minWidth: 40)
      }
    }
  }
}
