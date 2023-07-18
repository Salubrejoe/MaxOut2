
import SwiftUI
//import SymbolPicker


final class AddEditViewModel: ObservableObject {
  @Published var showSymbolPicker = false
  
//  let symbolGroup: SymbolGroup = SymbolGroup(symbols: [
//    "figure.run",
//    "figure.roll",
//    "figure.roll.runningpace",
//    "figure.american.football",
//    "figure.archery",
//    "figure.australian.football",
//    "figure.badminton",
//    "figure.barre",
//    "figure.baseball",
//    "figure.basketball",
//    "figure.bowling",
//    "figure.boxing",
//    "figure.climbing",
//    "figure.cooldown",
//    "figure.core.training",
//    "figure.cricket",
//    "figure.skiing.crosscountry",
//    "figure.cross.training",
//    "figure.curling",
//    "figure.dance",
//    "figure.disc.sports",
//    "figure.skiing.downhill",
//    "figure.elliptical",
//    "figure.equestrian.sports",
//    "figure.fencing",
//    "figure.fishing",
//    "figure.flexibility",
//    "figure.strengthtraining.functional",
//    "figure.golf",
//    "figure.gymnastics",
//    "figure.hand.cycling",
//    "figure.handball",
//    "figure.highintensity.intervaltraining",
//    "figure.hiking",
//    "figure.hockey",
//    "figure.hunting",
//    "figure.indoor.cycle",
//    "figure.jumprope",
//    "figure.kickboxing",
//    "figure.lacrosse",
//    "figure.martial.arts",
//    "figure.mind.and.body",
//    "figure.mixed.cardio",
//    "figure.open.water.swim",
//    "figure.outdoor.cycle",
//    "oar.2.crossed",
//    "figure.pickleball",
//    "figure.pilates",
//    "figure.play",
//    "figure.pool.swim",
//    "figure.racquetball",
//    "figure.rolling",
//    "figure.rower",
//    "figure.rugby",
//    "figure.sailing",
//    "figure.skating",
//    "figure.snowboarding",
//    "figure.soccer",
//    "figure.socialdance",
//    "figure.softball",
//    "figure.squash",
//    "figure.stair.stepper",
//    "figure.stairs",
//    "figure.step.training",
//    "figure.surfing",
//    "figure.table.tennis",
//    "figure.taichi",
//    "figure.tennis",
//    "figure.track.and.field",
//    "figure.strengthtraining.traditional",
//    "figure.volleyball",
//    "figure.water.fitness",
//    "figure.waterpolo",
//    "figure.wrestling",
//    "figure.yoga",
//    "dumbbell",
//    "dumbbell.fill",
//    "soccerball",
//    "baseball",
//    "basketball",
//    "football",
//    "tennis.racket",
//    "hockey.puck",
//    "cricket.ball",
//    "tennisball",
//    "volleyball",
//    "lungs.fill",
//    "hand.raised.fingers.spread.fill",
//    "heart.fill",
//    "bolt.heart.fill",
//    "brain.head.profile",
//    "stopwatch.fill",
//    "bolt.fill",
//    "chevron.backward.circle.fill",
//    "chevron.right.circle.fill",
//    "chevron.up.circle.fill",
//    "chevron.down.circle.fill",
//    "bicycle",
//    "scooter",
//    "seal.fill",
//    "shield.fill"
//  ])
  

  
  func save(_ exercise: Exercise)  throws {
    let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
    if exercise.id.isEmpty {
      var newExercise = exercise
      newExercise.id = UUID().uuidString
      try? ExercisesManager.shared.save(exercise: newExercise, userId: userId)
    }
    else {
      try? ExercisesManager.shared.save(exercise: exercise, userId: userId)
    }
  }
}
