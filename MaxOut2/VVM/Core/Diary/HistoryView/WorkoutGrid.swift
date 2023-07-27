import SwiftUI

struct WorkoutGrid: View {
  @EnvironmentObject var controller: AuthController
  @EnvironmentObject var model: HistoryViewModel
  
  let columns = [GridItem(.adaptive(minimum: 300))]

  var body: some View {
    ScrollViewReader { value in
      LazyVGrid(columns: columns) {
        elements
      }
      .padding(.vertical, 10)
      .onChange(of: model.focusedDate) { newValue in
        withAnimation {
          value.scrollTo(newValue, anchor: .center)
        }
      }
    }
    .animation(.spring(), value: model.workouts)
  }

  @ViewBuilder // MARK: - LIST
  private var elements: some View {
    
    ForEach(model.groupedWorkouts, id: \.0) { section in
      
      // MARK: SECTIONS by month
      HStack {
        Text(section.0)
          .font(.caption2.bold())
        Spacer()
      }
      .edgesIgnoringSafeArea(.horizontal)
      .foregroundColor(.secondary)
      .padding(.horizontal)
      
      ForEach(section.1) { workout in
        NavigationLink {
//          WorkoutDetailView(workout: workout)
          Text("WORKOUT DETAIL VIEW")
        } label: {
          WorkoutCell(workout: workout) {
            withAnimation {
              model.delete(workout)
            }
          }
        }
        .id(model.yearMonthDay(from: workout.routine.dateStarted))
      }
    }
  }
}


// MARK: - WORKOUT CELL
struct WorkoutCell: View {
  let workout: Workout
  let contextMenuAction: () -> ()
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(workout.routine.title)
          .font(.headline)
          .foregroundColor(.accentColor)
        Spacer()
        Text("\(workout.routine.duration.asTimeString(style: .short))")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Text(workout.routine.dateStarted.formatted(date: .abbreviated, time: .omitted))
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    
    .frame(maxWidth: 300)
    .cellStyle()
    
    
    .contextMenu {
      deleteButton
    }
    .animation(.spring(), value: workout)
    
  }
  
  // MARK: - ContextMenu DELETE
  @ViewBuilder
  private var deleteButton: some View {
    Button {
      contextMenuAction()
    } label: {
      Label("Delete", systemImage: "trash")
    }
  }
}
