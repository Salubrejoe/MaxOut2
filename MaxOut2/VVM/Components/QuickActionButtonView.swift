
import SwiftUI

struct QuickActionButtonView: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .stroke(Color.yellow,
                style: StrokeStyle(lineWidth: 2,
                                   lineCap: .round,
                                   lineJoin: .round,
                                   miterLimit: 0,
                                   dash: [3],
                                   dashPhase: 0))
      
      VStack(alignment: .leading) {
        
        // big
        Image("exercisesList")
          .resizable()
          .scaledToFit()
          .frame(width: 60, height: 60)
        
        // small
        Spacer()
        HStack(spacing: 3) {
          Text("Exercise List")
            .font(.subheadline)
          Image(systemName: "chevron.right")
            .imageScale(.small)
            .scaleEffect(0.5)
            .offset(y: 1)
          Spacer()
        }
        
      }
      .padding(20)
    }
    .frame(width: 160, height: 160)
  }
}

struct QuickActionButtonView_Previews: PreviewProvider {
  static var previews: some View {
    QuickActionButtonView()
  }
}
