import SwiftUI

extension BobView {
  @ViewBuilder // MARK: - STRENGTH
  func strengthBob() -> some View {
    container { width in
      
      HStack {
        TextField("0", text: $bob.kg)
          .bobTFStyle()
          .numbersOnly($bob.kg)
        
        TextField("0", text: $bob.reps)
          .bobTFStyle()
          .numbersOnly($bob.kg, includeDecimal: false)
      }.frame(width: width * 0.4)
      
      BobGauge(bob: $bob)
        .frame(width: width * 0.35)
        .frame(height: 37)
        .opacity(bob.isCompleted ? 0.2 : 1)
    }
  }
  
  
  public var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "mm:ss"
    return formatter
  }
  @ViewBuilder // MARK: - STRETCHING
  func stretchingBob() -> some View {
    HStack {
      Spacer()
      DurationPicker(hh: $hh, mm: $mm, ss: $ss)
        .padding()
    }
  }
  
  
  @ViewBuilder // MARK: - CARDIO
  func cardioBob() -> some View {
    container { width in
      Image(systemName: "figure.rower")
        .frame(width: width * 0.35)
      
      HStack {
        TextField("0", text: $bob.distance)
          .bobTFStyle()
          .numbersOnly($bob.kg)
        
        DurationPicker(hh: $hh, mm: $mm, ss: $ss)
      }
      .frame(width: width * 0.4)
    }
    
  }
}




// MARK: - CONTAINER
extension BobView {
  
  @ViewBuilder
  private func container<Content: View>(@ViewBuilder content: @escaping (CGFloat) -> Content) -> some View {
    Group {
      GeometryReader { proxy in
        let width = proxy.size.width
        let index = session.bobs.firstIndex(of: bob) ?? 0
        HStack {
          Text("\(index + 1)")
            .foregroundColor(.secondary)
            .padding(.leading, 4)
            .frame(width: width * 0.09)
            
          
          content(width)
          
          Button {
            self.bob.isCompleted.toggle()
          } label: {
            Image(systemName: "checkmark")
              .foregroundColor(bob.isCompleted ? .green : .primary)
          }
          .padding(.trailing)
          .frame(width: width * 0.10)
        }
        ///CORRECTING GEO READER
        .padding(.top, 5)
      }
    }
    .frame(minHeight: 46)
    .font(.headline)
  }
}
