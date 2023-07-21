import SwiftUI


struct CalendarWidget: View {
  var body: some View {
    GroupBox {
      HStack {
        WidgetCalendarView(size: 90)
        Spacer()
      }
    }
    .groupBoxStyle(RegularMaterialStyle())
  }
}


struct GridData: Identifiable {
  var id: String { date.description }
  let opacity: Double
  let date: Date
  
  var monthYear: String {
    let calendar = Calendar.current
    let monthSymbols = calendar.monthSymbols
    let monthInt = calendar.component(.month, from: date)
    let month = monthSymbols[monthInt - 1]
    let year = calendar.component(.year, from: date)
    return "\(month) \(year)"
  }
  
  var day: String {
    String(Calendar.current.component(.day, from: date))
  }
  
  static let shared: [GridData] = {
    var data: [GridData] = []
    let today = Date()
    for i in 0..<49 {
      let randomOpacity = Double(Int.random(in: 0...10))
      let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
      let widgetData = GridData(opacity: randomOpacity/10, date: date ?? Date())
      data.append(widgetData)
    }
    return data.reversed()
  }()
}

struct WidgetCalendarView: View {
  let widgetData = GridData.shared
  let size: CGFloat
  var body: some View {
    VStack(alignment: .leading) {
      grid
        .background(ContainerRelativeShape().fill(Color.clear))
      VStack(alignment: .leading) {
        Text("last 50 days")
          .font(.caption)
          .foregroundColor(.secondary)
        
        Text("1983 kg")
          .font(.largeTitle)
          .minimumScaleFactor(0.6)
          .bold()
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
          ForEach(widgetData) { datum in
            Rectangle()
              .frame(width: size(proxy), height: size(proxy))
              .foregroundColor(.indigo.opacity(datum.opacity))
              .cornerRadius(size(proxy)/2)
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

struct WidgetCalendarView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      WidgetCalendarView(size: 150)
    }
  }
}


