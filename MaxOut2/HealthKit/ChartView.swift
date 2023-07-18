import SwiftUI

struct ChartView: View {
  let values: [Int]
  let labels: [String]
  let xAxisLabels: [String]
  
  var body: some View {
    GeometryReader { proxy in
      
      VStack {
        HStack {
          Text("Exercise minutes")
            .font(.headline)
            .foregroundColor(.primary)
          Spacer()
          Image(systemName: "chevron.right")
            .resizable()
            .scaledToFit()
            .frame(width: 10, height: 10)
            .clipShape(Circle())
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        
        
        HStack(alignment: .bottom) {
          ForEach(0..<values.count, id: \.self) { index in
            let max = values.max() ?? 1
            
            VStack {
              RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.green.gradient.shadow(.inner(radius: 2, y: -2)))
                .opacity(Double(values[index] > 50 ? 1 : 0.5))
                .frame(width: 24)
                .frame(height: CGFloat(values[index]) / CGFloat(max) * proxy.size.height * 0.6)
              Text(xAxisLabels[index])
                .font(.caption)
                .foregroundColor(.gray
                )
            }
            
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
    }
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    let values = [213, 456, 33, 222, 46, 355, 322]
    let labels = ["213", "456", "33", "2", "35", "355", "322"]
    let xAxisLabels = ["May 30", "May 31", "June 1", "June 2", "June 3", "June 4", "June 5"]
    ChartView(values: values, labels: labels, xAxisLabels: xAxisLabels)
  }
}
