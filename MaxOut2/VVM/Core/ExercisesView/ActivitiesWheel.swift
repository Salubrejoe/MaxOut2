
import SwiftUI

struct ActivitiesWheel: View {
  @ObservedObject var model: ExercisesViewModel
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      ScrollViewReader { pageScroller in
        HStack {
          ForEach(model.groupedActivities) { activity in
            Button {
              model.selectedActivity = activity
            } label: {
              Capsule()
                .stroke(model.selectedActivity == activity ? Color.primary : Color.clear, lineWidth: 1)
                .frame(width: model.selectedActivity == activity ? 140 : 46)
                .frame(height: 37)
                
                .overlay {
                  HStack {
                    Image(systemName: activity.logo)
                      .imageScale(.large)
                      .foregroundStyle(model.selectedActivity == activity ? Color.exerciseRing.gradient : Color.secondary.gradient)
                    
                    if model.selectedActivity == activity {
                      Text(activity.name.capitalized)
                        .font(.caption)
                        .foregroundColor(.primary)
                    }
                  }
                  .padding(.horizontal, 5)
                }
            }
            .id(activity.id)
            .scaleEffect(model.selectedActivity == activity ? 1.1 : 1)
          }
        }
        .animation(.spring(), value: model.selectedActivity)
        .onChange(of: model.selectedActivity) { value in
          pageScroller.scrollTo(value.id, anchor: .center)
        }
      }
      .padding(.horizontal)
      .frame(height: 60)
    }
  }
}

struct ActivitiesWheel_Previews : PreviewProvider {
  static var previews: some View {
    ActivitiesWheel(model: ExercisesViewModel())
  }
}


// MARK: - FROM HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

struct EquipmentWheel: View {
  @ObservedObject var model: ExercisesViewModel
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      ScrollViewReader { pageScroller in
        HStack {
          ForEach(model.groupedActivities) { activity in
            Button {
              model.selectedActivity = activity
            } label: {
              Capsule()
                .stroke(model.selectedActivity == activity ? Color.primary : Color.clear, lineWidth: 2)
                .frame(width: model.selectedActivity == activity ? 130 : 46)
                .frame(height: 30)
              
                .overlay {
                  HStack {
                    Image(systemName: activity.logo)
                      .imageScale(.large)
                      .foregroundStyle(model.selectedActivity == activity ? Color.exerciseRing.gradient : Color.secondary.gradient)
                    
                    if model.selectedActivity == activity {
                      Text(activity.name.capitalized)
                        .font(.headline)
                        .foregroundColor(.primary)
                    }
                  }
                  .padding(.horizontal, 5)
                }
            }
            .id(activity.id)
            .scaleEffect(model.selectedActivity == activity ? 1.1 : 1)
          }
        }
        .animation(.spring(), value: model.selectedActivity)
        .onChange(of: model.selectedActivity) { value in
          pageScroller.scrollTo(value.id, anchor: .center)
        }
      }
      .padding(.horizontal)
      .frame(height: 60)
    }
  }
}
