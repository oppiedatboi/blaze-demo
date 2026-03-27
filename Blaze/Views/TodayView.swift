import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showAddHabit = false
    @State private var confettiHabitID: PersistentIdentifier?

    var body: some View {
        NavigationStack {
            ZStack {
                BlazeTheme.background.ignoresSafeArea()

                if habits.isEmpty {
                    emptyState
                } else {
                    habitList
                }
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddHabit = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: BlazeTheme.iconWeight))
                            .foregroundStyle(BlazeTheme.accent)
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView()
            }
            .overlay {
                if confettiHabitID != nil {
                    ConfettiView()
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            FoxMascot()
                .frame(width: 180, height: 180)

            Text("No habits yet!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(BlazeTheme.textPrimary)

            Text("Tap + to start building\nyour daily streak")
                .font(.subheadline)
                .foregroundStyle(BlazeTheme.textSecondary)
                .multilineTextAlignment(.center)

            Button {
                showAddHabit = true
            } label: {
                Label("Add First Habit", systemImage: "plus")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(BlazeTheme.accent, in: Capsule())
            }
        }
        .padding(.bottom, 80)
    }

    private var habitList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(habits) { habit in
                    HabitRow(habit: habit) {
                        let wasCompleted = habit.isCompletedToday
                        habit.toggleToday(context: context)
                        if !wasCompleted {
                            confettiHabitID = habit.persistentModelID
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                confettiHabitID = nil
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }
}
