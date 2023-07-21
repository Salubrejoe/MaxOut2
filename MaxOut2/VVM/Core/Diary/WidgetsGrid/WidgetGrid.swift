import SwiftUI
import HealthKit

struct WidgetGrid: View {
  @EnvironmentObject var manager: HealthKitManager
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
        CalendarWidget()
      }
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 307))]) {
        MediumCardView("Exercise Minutes", color: .primary, style: RegularMaterialStyle()) {
          NavigationLink {
            HistoryView()
          } label: {
            ExerciseMinutesWidget()
              .environmentObject(HealthKitManager())
          }
        }
        MediumCardView("Body Mass", color: .primary, style: RegularMaterialStyle()) {
          NavigationLink {
            WeightView()
          } label: {
            BodyMassChart()
              .environmentObject(HealthKitManager())
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
              
            Text("Last 7 days")
              .font(.footnote)
              .foregroundColor(.secondary)
          }
          Spacer()
          Image(systemName: activity.image)
            .imageScale(.large)
            .foregroundStyle(Color.exerciseRing.gradient)
        }
        .padding(.leading, 2)
        
        Spacer()
        HStack {
          Spacer()
          Text(activity.durationString)
            .font(.largeTitle.bold())
            .foregroundStyle(Color.primary.gradient)
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
      .cornerRadius(14)
  }
}

struct BackgroundStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.content
      .padding()
      .background(Color.systemBackground)
      .cornerRadius(14)
  }
}

