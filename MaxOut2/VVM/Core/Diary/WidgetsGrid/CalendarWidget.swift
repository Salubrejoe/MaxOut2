import SwiftUI


struct CalendarWidget: View {
  @EnvironmentObject var model: HistoryViewModel
  
  var body: some View {
    GroupBox {
      WidgetCalendarView(widgetData: model.widgetData, size: 85)
    }
    .groupBoxStyle(RegularMaterialStyle())
    .task {
      model.getViewInfo()
    }
  }
}

struct CalendarGridData: Identifiable, Equatable {
  var id: String { date.description }
  let opacity: Double
  let date: Date
}

struct WidgetCalendarView: View {
  @EnvironmentObject var manager: HealthKitManager
  let widgetData: [CalendarGridData]?
  let size: CGFloat
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("last 10 weeks")
        .padding(.bottom, 3)
        .font(.caption)
        .foregroundColor(.secondary)
      Group {
        grid
      }
      .padding(.leading, 5)
      .frame(maxWidth: .infinity)
      Spacer()
      HStack {
        Spacer()
        Text(Date().formattedString())
          .font(.title2.bold())
          .foregroundColor(.primary)
      }
    }
  }
}

extension WidgetCalendarView {
  
  @ViewBuilder
  private var grid: some View {
    Group {
      GeometryReader() { proxy in
        LazyHGrid(rows: rows(proxy), spacing: spacing(proxy)) {
          if let widgetData {
            ForEach(widgetData) { datum in
              Circle()
                .frame(width: size(proxy), height: size(proxy))
                .foregroundStyle(Color.primary.gradient.shadow(.inner(radius: 3)))
                .opacity(datum.opacity != 0 ? datum.opacity : 0.1)
            }
          }
        }
        .frame(width: edge(proxy), height: edge(proxy))
      }
    }
    .frame(width: size)
    .frame(height: size)
  }
  
  private func rows(_ proxy: GeometryProxy) -> [GridItem] {
    [
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy))
    ]
  }
  
  private func size(_ proxy: GeometryProxy) -> CGFloat {
    let containerWidth = proxy.size.width
    let dayWidth = containerWidth / 7
    return dayWidth * 3 / 4
  }
  
  private func spacing(_ proxy: GeometryProxy) -> CGFloat {
    size(proxy) / 3
  }
  
  func edge(_ proxy: GeometryProxy) -> CGFloat {
    let totalSpacing = spacing(proxy) * 6
    let totalDaysHeight = size(proxy) * 7
    return totalSpacing + totalDaysHeight
  }
}


extension Date {
  func formattedString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    let dayString = dateFormatter.string(from: self)
    
    dateFormatter.dateFormat = "MMM"
    let monthString = dateFormatter.string(from: self)
    
    dateFormatter.dateFormat = "dd"
    let dayNumber = Int(dateFormatter.string(from: self)) ?? 0
    
    return "\(dayString), \(monthString) \(dayNumber)"
  }
}

extension Int {
  func getOrdinalSuffix() -> String {
    if 10...20 ~= self {
      return "th"
    } else {
      switch self % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
      }
    }
  }
}
