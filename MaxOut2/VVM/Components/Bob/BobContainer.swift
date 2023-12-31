import SwiftUI

extension BobView {
  @ViewBuilder // MARK: - STRENGTH
  func strengthBob() -> some View {
    container { width in
      
      HStack(spacing: 0) {
        BobKgRepsTextField(value: $bob.mass, isCompleted: $bob.isCompleted, unit: "kg")
          .bobInputStyle
          .frame(width: width * 0.2)
        
        BobKgRepsTextField(value: $bob.reps, isCompleted: $bob.isCompleted, unit: "reps")
          .bobInputStyle
          .frame(width: width * 0.2)
      }
      
      BobGauge(bob: $bob)
        .padding(.horizontal)
        .frame(width: width * 0.4)
        .frame(height: 37)
        .opacity(bob.isCompleted ? 0.2 : 1)
    }
  }


  @ViewBuilder // MARK: - STRETCHING
  func stretchingBob() -> some View {
    container { width in
      HStack(spacing: 0) {
        Text("")
          .frame(width: width * 0.35)
          
        DurationPicker(hh: $bob.duration[0], mm: $bob.duration[1], ss: $bob.duration[2], isCompleted: $bob.isCompleted)
          .bobInputStyle
          .frame(width: width * 0.42)
          
      }
    }
  }
  
  
  @ViewBuilder // MARK: - CARDIO
  func cardioBob() -> some View {
    container { width in
      HStack(spacing: 0) {
        Text("")
          .frame(width: width * 0.25)
          
        KmTF(distance: $bob.distance, isCompleted: $bob.isCompleted)
          .bobInputStyle
          .frame(width: width * 0.20)
          
        DurationPicker(hh: $bob.duration[0], mm: $bob.duration[1], ss: $bob.duration[2], isCompleted: $bob.isCompleted)
          .bobInputStyle
          .frame(width: width * 0.35)
          
      }
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
        HStack(spacing: 0) {
          Text("\(index + 1)")
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.leading, 4)
            .frame(width: width * 0.10)
            
          content(width)
          
          Button {
            self.bob.isCompleted.toggle()
          } label: {
            Image(systemName: "checkmark")
              .foregroundColor(bob.isCompleted ? .green : .systemBackground)
              .padding(2)
              .background(bob.isCompleted ? .clear : .primary)
              .cornerRadius(5)
          }
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


extension View {
  var bobInputStyle: some View {
    self
      
      .multilineTextAlignment(.center)
      .fontWeight(.semibold)
      .foregroundStyle(.primary)
      .frame(maxWidth: .infinity)
      .frame(minWidth: 60)
      .frame(height: 32)
      .background(.ultraThinMaterial)
      .cornerRadius(10)
      .padding(.horizontal)
  }
}
