import SwiftUI
import HealthKit

struct WidgetGrid: View {
  @EnvironmentObject var manager: HealthKitManager
  @StateObject var historyModel = HistoryViewModel()
  
  @State private var isShowingHistory      = false
  @State private var isShowingExerciseTime = false
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
        CalendarWidget()
          .environmentObject(historyModel)
          .onTapGesture { isShowingHistory = true }
          .sheet(isPresented: $isShowingHistory) {
            HistoryView()
              .environmentObject(historyModel)
          }
      }
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 307))]) {
        MediumCardView("Exercise Time", color: .primary, style: RegularMaterialStyle()) {
          ExerciseMinutesWidget()
            .environmentObject(manager)
            
            .onTapGesture { isShowingExerciseTime = true }
            .sheet(isPresented: $isShowingExerciseTime) {
              ExerciseTimeView()
                .environmentObject(manager)
                .presentationDetents([.medium])
            }
        }
        MediumCardView("Body Mass", color: .primary, style: RegularMaterialStyle()) {
          NavigationLink {
            WeightView()
          } label: {
            BodyMassChart()
              .environmentObject(manager)
          }
        }
      }
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
        ForEach(manager.currentActivities) {
          SmallCardView(activity: $0, style: RegularMaterialStyle())
        }
      }
    }
  }
}

struct WidgetGrid_Previews: PreviewProvider {
  static var previews: some View {
    WidgetGrid()
  }
}


// MARK: - CARD VIEW
struct MediumCardView<Content: View, Style: GroupBoxStyle>: View {
  
  let text: String
  let link: String?
  let color: Color
  let style: Style
  let content: () -> Content

  init(_ text: String, link: String? = nil, color: Color, style: Style, content: @escaping () -> Content) {
    self.text = text
    self.link = link
    self.color = color
    self.style = style
    self.content = content
  }
  
  var body: some View {
    GroupBox {
      ZStack(alignment: .topLeading) {
        Text(text)
          .fontWeight(.semibold)
          .foregroundColor(color)
        content()
          
      }
      .padding(.leading, 4)
    }
    .frame(height: 150)
    .groupBoxStyle(style)
  }
}

// MARK: - SMALL CARD VIEW
struct SmallCardView<Style: GroupBoxStyle>: View {
  
  let activity: Activity
  let style: Style
  
  var body: some View {
    GroupBox {
      VStack(alignment: .leading, spacing: 0) {
        HStack(alignment: .top) {
          VStack(alignment: .leading) {
            Text(activity.name)
              .foregroundColor(.primary)
              .fontWeight(.semibold)
              
            Text("last 7 days")
              .font(.footnote)
              .foregroundColor(.secondary)
          }
          Spacer()
          Image(systemName: activity.logo)
            .imageScale(.large)
            .foregroundStyle(Color.exerciseRing.gradient)
        }
        .padding(.leading, 2)
        
        Spacer()
        HStack {
          let hour = activity.durationString.hour
          let minute = activity.durationString.minute
          Spacer()
          if hour != "" {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
              Text(hour)
                .font(.largeTitle)
                .foregroundStyle(Color.primary.gradient)
              Text("h")
                .font(.title)
                .foregroundStyle(Color.secondary.gradient)
            }
          }
          if minute != "00" {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
              Text(minute)
                .font(.largeTitle)
                .foregroundStyle(Color.primary.gradient)
              Text("m")
                .font(.title)
                .foregroundStyle(Color.secondary.gradient)
            }
          }
        }
      }
      .frame(height: 150)
    }
    .groupBoxStyle(style)
  }
}

struct RegularMaterialStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.content
      .padding([.horizontal, .top])
      .padding(.bottom, 10)
      .background(.regularMaterial)
      .cornerRadius(11)
  }
}

struct SecondaryBackgroundStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.content
      .padding([.horizontal, .top])
      .padding(.bottom, 10)
      .background(Color.secondarySytemBackground)
      .cornerRadius(11)
  }
}

