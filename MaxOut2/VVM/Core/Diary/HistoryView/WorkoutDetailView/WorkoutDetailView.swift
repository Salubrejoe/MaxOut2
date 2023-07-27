//import SwiftUI
//
//
//@MainActor
//final class WorkoutDetailViewModel: ObservableObject {
//  func isBestBob(session: Session, index: Int) -> Bool {
//    
//    let bestBob = try? session.calculateBestBob(for: session).index
//    return index == bestBob
//  }
//}
//
//struct WorkoutDetailView: View {
//  @StateObject private var model = WorkoutDetailViewModel()
//  
//  let workout: Workout
//  
//  var dates: String?
//  
//  
//  // MARK: - init()
//  init(workout: Workout) {
//    self.workout = workout
//    self.dates = "\(workout.routine.dateStarted.formatted(date: .abbreviated, time: .shortened)) -> \(workout.routine.dateEnded?.formatted(date: .omitted, time: .shortened) ?? "WorkoutView dateString err")"
//  }
//  
//  var body: some View {
//    ScrollView(showsIndicators: false, content: {
//      VStack(alignment: .leading, spacing: 8) {
//        
//        Text(dates ?? "WorkoutView dateString Error")
//          .font(.subheadline)
//          .foregroundColor(.secondary)
//        
//        Divider()
//        
//        localSessionView
//        
//        Spacer()
//      }
//    })
//    .navigationTitle(workout.routine.title)
//    .padding()
//  }
//}
//
//
//extension WorkoutDetailView {
//  
//  @ViewBuilder // MARK: - Local SESSION VIEW
//  private var localSessionView: some View {
//    VStack {
//      ForEach(workout.sessions) { session in
//        
//        Text(session.exerciseName).font(.title3)
//        
//        localBobsView(for: session)
//        Divider()
//      }
//    }
//  }
//  
//  @ViewBuilder // MARK: - Local BOB VIEW
//  private func localBobsView(for session: Session) -> some View {
//    VStack {
//      ForEach(session.bobs.indices, id: \.self) { index in
//        let bob = session.bobs[index]
//        let isBestBob = model.isBestBob(session: session, index: index)
//        
//        if session.category == "cardio" {
//          distanceDurationBobCell(bob: bob, isBestBob: isBestBob)
//        }
//        else {
//          weightRepsBobCell(bob: bob, isBestBob: isBestBob)
//        }
//      }
//    }
//  }
//  
//  
//  // MARK: - Bob Cells
//  
//  private func distanceDurationBobCell(bob: Bob, isBestBob: Bool) -> some View {
//    
//    HStack {
//      Text(bob.distance.formatted() + "Km in " + bob.duration.description + "Min")
//        .padding(6)
//        .background(isBestBob ? Color.green.opacity(0.3) : Color.clear)
//        .cornerRadius(5)
//      Spacer()
//      if isBestBob {
//        Text("🥳 Best Set! Congrats")
//          .bold()
//          .foregroundColor(.green.opacity(0.3))
//      }
//    }
//  }
//  
//  private func weightRepsBobCell(bob: Bob, isBestBob: Bool) -> some View {
//    
//    HStack {
//      Text(bob.kg.formatted() + "kg x " + bob.reps.formatted())
//        .padding(6)
//        .background(isBestBob ? Color.green.opacity(0.3) : Color.clear)
//        .cornerRadius(5)
//      Spacer()
//      if isBestBob {
//        Text("🥳 Best Set! Congrats")
//          .bold()
//          .foregroundColor(.green.opacity(0.3))
//      }
//    }
//  }
//}
//
