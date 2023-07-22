import SwiftUI

enum RayCase: String, CaseIterable {
  case shoulders = "Sh"
  case arms = "Ar"
  case chest = "Ch"
  case back = "Ba"
  case core = "Co"
  case legs = "Le"
}

struct RadarChart: View {

  var mainColor      : Color
  var subtleColor    : Color
  var center         : CGPoint
  var labelWidth     : CGFloat = 50
  var size           : CGFloat
  var numberOfLines  : Int
  var dimensions     : [Ray]
  var data           : [PolygonData]

  init(size: CGFloat, labelWidth: CGFloat = 50, mainColor: Color, subtleColor: Color, numberOfLines: Int, dimensions: [Ray], data: [PolygonData]) {
    self.size = size
    self.center = CGPoint(x: size/2, y: size/2)
    self.mainColor = mainColor
    self.labelWidth = labelWidth
    self.subtleColor = subtleColor
    self.numberOfLines = numberOfLines
    self.dimensions = dimensions
    self.data = data
  }
  
  @State var showLabels = false

  var body: some View {
    ZStack {
      
      mainSpokes
      
      labels
      
      outerBorder
      
      incrementaDividers
      
      dataPolygons
    }
    .frame(width: size, height: size)
  }
}

extension RadarChart {
  
  @ViewBuilder // MARK: - MAIN SPOKES
  private var mainSpokes: some View {
    Path { path in
      
      for i in 0..<self.dimensions.count {
        let angle = radiantsAngleFromFraction(numerator: i, denominator: self.dimensions.count)
        let x = (self.size - (20 + self.labelWidth))/2 * cos(angle) // PADDING OF 25 EACH SIDE
        let y = (self.size - (20 + self.labelWidth))/2 * sin(angle)
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
      }
      
    }
    .stroke(self.mainColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
  }
  
  @ViewBuilder // MARK: - LABELS
  private var labels: some View {
      ForEach(0..<self.dimensions.count, id: \.self) { i in
        
        if labelWidth > 0 {
        Text(self.dimensions[i].rayCase.rawValue)
        
          .font(.system(size: 10))
          .foregroundColor(self.subtleColor)
          .frame(width:self.labelWidth, height:10)
          .rotationEffect(.degrees(rotationDegrees(numerator: i, denominator: self.dimensions.count)))
        
        
          .background(Color.clear)
          .offset(x: (self.size - (20))/2)
          .rotationEffect(.radians(Double(radiantsAngleFromFraction(numerator: i, denominator: self.dimensions.count))))
      }
    }
  }
  
  @ViewBuilder // MARK: - OUTER BORDER
  private var outerBorder: some View {
    Path { path in
      
      for i in 0..<self.dimensions.count + 1 {
        let angle = radiantsAngleFromFraction(numerator: i, denominator: self.dimensions.count)
        
        let x = (self.size - (20 + self.labelWidth))/2 * cos(angle)
        let y = (self.size - (20 + self.labelWidth))/2 * sin(angle)
        if i == 0 {
          path.move(to: CGPoint(x: center.x + x, y: center.y + y))
        } else {
          path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
        }
        
        
      }
      
    }
    .stroke(self.mainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
  }
  
  @ViewBuilder // MARK: - INCREMENTAL DIVIDERS
  private var incrementaDividers: some View {
    ForEach(0..<self.numberOfLines, id: \.self) { j in
      Path { path in
        
        
        for i in 0..<self.dimensions.count + 1 {
          let angle = radiantsAngleFromFraction(numerator: i, denominator: self.dimensions.count)
          let size = ((self.size - (20 + self.labelWidth))/2) * (CGFloat(j + 1)/CGFloat(self.numberOfLines + 1))
          
          let x = size * cos(angle)
          let y = size * sin(angle)
          if i == 0 {
            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
          } else {
            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
          }
          
        }
        
      }
      .stroke(self.subtleColor, style: StrokeStyle(lineWidth: 0.5, lineCap: .round, lineJoin: .round))
      
      
    }
  }
  
  
  @ViewBuilder // MARK: - DATA POLYGONs
  private var dataPolygons: some View {
    ForEach(0..<self.data.count, id: \.self) { j -> AnyView in
      //Create the path
      let path = Path { path in
        
        
        for i in 0..<self.dimensions.count + 1 {
          let thisDimension = self.dimensions[i == self.dimensions.count ? 0 : i]
          let maxVal = thisDimension.maxValue
          let dataPointVal: Double = {
            
            // Find the ray for "chest" in data point and scale it!
            for dataPointRay in self.data[j].entrys {
              if thisDimension.rayCase == dataPointRay.rayCase {
                return dataPointRay.value
              }
            }
            return 0
          }()
          let angle = radiantsAngleFromFraction(numerator: i == self.dimensions.count ? 0 : i, denominator: self.dimensions.count)
          let size = ((self.size - (20 + self.labelWidth))/2) * (CGFloat(dataPointVal)/CGFloat(maxVal))
          
          
          let x = size * cos(angle)
          let y = size * sin(angle)
          
          if i == 0 {
            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
          } else {
            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
          }
          
        }
        
      }
      
      //Stroke and Fill
      return AnyView(
        ZStack{
          path
            .stroke(self.data[j].color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
          path
            .foregroundColor(self.data[j].color).opacity(0.2)
        }
      )
      
      
    }
  }
  
  // MARK: - ANGLE CONVERSIONS
  private func degreeToRadiants(_ number: CGFloat) -> CGFloat { number * .pi/180 }
  
  private func radiantsAngleFromFraction(numerator: Int, denominator: Int) -> CGFloat { degreeToRadiants(degreeAngleFromFraction(numerator: numerator, denominator: denominator)) }
  
  private func degreeAngleFromFraction(numerator: Int, denominator: Int) -> CGFloat { 360 * (CGFloat((numerator))/CGFloat(denominator)) }
  
  private func rotationDegrees(numerator: Int, denominator: Int) -> CGFloat {
    (degreeAngleFromFraction(numerator: numerator, denominator: denominator) > 90 && degreeAngleFromFraction(numerator: numerator, denominator: denominator) < 270) ? 180 : 0
  }
}

// MARK: - RAY
struct Ray: Identifiable {
  var id: String
  var name: String
  var maxValue: Double
  var rayCase: RayCase
  init(maxValue: Double, rayCase: RayCase) {
    self.id = UUID().uuidString
    self.name = rayCase.rawValue
    self.maxValue = maxValue
    self.rayCase = rayCase
  }
}


// MARK: - RAY ENTRY
struct RayEntry {
  var rayCase : RayCase
  var value   : Double
}


// MARK: - DATA POINT
struct PolygonData: Identifiable {
  var id     : String
  var entrys : [RayEntry]
  var color  : Color

  init(shoulders: Double, arms: Double, chest: Double, back: Double, core: Double, legs: Double, color: Color){
    self.entrys = [
      RayEntry(rayCase: .shoulders, value: shoulders),
      RayEntry(rayCase: .arms, value: arms),
      RayEntry(rayCase: .chest, value: chest),
      RayEntry(rayCase: .back, value: back),
      RayEntry(rayCase: .core, value: core),
      RayEntry(rayCase: .legs, value: legs),
    ]
    self.color = color
    self.id = UUID().uuidString
  }
}


