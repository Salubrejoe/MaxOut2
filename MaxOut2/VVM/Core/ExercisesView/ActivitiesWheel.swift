
import SwiftUI

struct MuscleGroupPicker: View {
  @ObservedObject var model: ExercisesViewModel
  
  let muscles  : [Muscle] = Muscle.allCases
  
  var body: some View {
    Menu {
      Section {
        Button {
          model.selectedMuscle = nil
        } label: {
          Label("See All", systemImage: "figure.arms.open")
        }
      }
      
      Section {
        ForEach(muscles, id: \.self) { muscle in
          Button { select(muscle) } label: {
            HStack {
              Image(muscle.muscleGroupImage)
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .padding(2)
              Text(muscle.rawValue.capitalized)
            }
          }
        }
      }
    } label: {
      label(for: model.selectedMuscle)
    }
    .onChange(of: model.selectedMuscle) { newValue in
      model.exercises = []
      model.addListenerToFavourites()
      if let muscle = model.selectedMuscle {
        model.exercises = model.exercises.filter { $0.primaryMuscles[0] == muscle.rawValue }
      }
    }
  }
  
  @ViewBuilder // MARK: - Label
  private func label(for selectedMuscle: Muscle?) -> some View {
    HStack(spacing: 0) {
      if let selectedMuscle {
        Image(selectedMuscle.muscleGroupImage)
          .resizable()
          .scaledToFit()
          .colorMultiply(Color(.systemPink))
          .frame(width: 20, height: 20)
          .padding(7)
        Text(selectedMuscle.rawValue.capitalized).bold()
          .font(.caption)
          .padding(.trailing)
          .foregroundStyle(Color(.systemPink).gradient)
      }
      else {
        Image(systemName: "figure.arms.open")
          .resizable()
          .scaledToFit()
          .frame(width: 20, height: 20)
          .foregroundStyle(Color.primary.gradient)
          .padding(7)
        
        Text("Body Parts").bold()
          .font(.caption)
          .padding(.trailing)
          .foregroundStyle(Color.primary.gradient)
      }
    }
    .frame(width: 155)
    .background(.ultraThinMaterial)
    .clipShape(Capsule())
  }
  
  private func select(_ muscle: Muscle) { model.selectedMuscle = muscle }
}

struct APicker: View {
  @ObservedObject var model: ExercisesViewModel
  
  var body: some View {
    Menu {
        Section {
          Button {
            model.selectedActivity = nil
          } label: {
            Label("See All", systemImage: "figure.arms.open")
          }
        }

        Section {
          ForEach(model.groupedActivities) { activity in
          Button { select(activity) } label: {
            Label(activity.name.capitalized, systemImage: activity.logo)
          }
        }
      }
    } label: {
      label(for: model.selectedActivity)
    }
  }
  
  @ViewBuilder // MARK: - SOMETHING
  private func label(for selectedActivity: Activity?) -> some View {
    HStack(spacing: 0) {
      Image(systemName: model.selectedActivity?.logo ?? "figure.arms.open")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
        .padding(7)
      
      Text(selectedActivity?.type.commonName.capitalized ?? "Category").bold()
        .font(.caption)
        .padding(.trailing)
    }
    .frame(width: 155)
    .foregroundStyle(model.selectedActivity != nil ? Color.exerciseRing.gradient : Color.primary.gradient)
    .background(.ultraThinMaterial)
    .clipShape(Capsule())
  }
  
  private func select(_ activity: Activity) { model.selectedActivity = activity }
}

struct ActivityPicker: View {
  @ObservedObject var model: ExercisesViewModel
  
  var body: some View {
    Picker(selection: $model.selectedActivity) {
      ForEach(model.groupedActivities) { activity in
        HStack {
          Image(systemName: activity.logo)
            .imageScale(.small)
            .foregroundStyle(model.selectedActivity == activity ? Color.exerciseRing.gradient : Color.secondary.gradient)
          
          Text(activity.name.capitalized)
            .font(.caption)
            .foregroundColor(.primary)
        }
        .tag(activity)
      }
    } label: {
      Image(systemName: model.selectedActivity?.logo ?? "figure.run")
        .resizable()
        .scaledToFit()
        .frame(width: 60, height: 60)
        .foregroundStyle(Color.exerciseRing.gradient)
        .background(.ultraThinMaterial)
        .clipShape(Circle())
    }
  }
}

struct ActivitiesWheel: View {
  @ObservedObject var model: ExercisesViewModel
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      ScrollViewReader { pageScroller in
        HStack {
          ForEach(model.groupedActivities) { activity in
            Button {
              if model.selectedActivity == activity {
                model.selectedActivity = nil
              }
              else {
                model.selectedActivity = activity
              }
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
        //        .onChange(of: model.selectedActivity) { value in
        //          pageScroller.scrollTo(value.id, anchor: .center)
        //        }
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
