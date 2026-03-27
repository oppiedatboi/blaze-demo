import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \Habit.createdAt) private var habits: [Habit]

    var body: some View {
        NavigationStack {
            ZStack {
                BlazeTheme.background.ignoresSafeArea()

                if habits.isEmpty {
                    VStack(spacing: 16) {
                        FoxMascot()
                            .frame(width: 140, height: 140)

                        Text("No stats yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(BlazeTheme.textPrimary)

                        Text("Complete habits to see your progress")
                            .font(.subheadline)
                            .foregroundStyle(BlazeTheme.textSecondary)
                    }
                    .padding(.bottom, 80)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            overviewCards
                            habitBreakdown
                        }
                        .padding()
                        .padding(.bottom, 100)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var overviewCards: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Total Habits",
                value: "\(habits.count)",
                icon: "list.bullet",
                color: BlazeTheme.accent
            )

            StatCard(
                title: "Completions",
                value: "\(habits.reduce(0) { $0 + $1.totalCompletions })",
                icon: "checkmark.circle.fill",
                color: BlazeTheme.success
            )

            StatCard(
                title: "Best Streak",
                value: "\(habits.map(\.longestStreak).max() ?? 0)",
                icon: "flame.fill",
                color: BlazeTheme.streak
            )
        }
    }

    private var habitBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Habit Breakdown")
                .font(.headline)
                .foregroundStyle(BlazeTheme.textPrimary)

            ForEach(habits) { habit in
                HStack(spacing: 12) {
                    Image(systemName: habit.icon)
                        .font(.system(size: 18, weight: BlazeTheme.iconWeight))
                        .foregroundStyle(habit.color)
                        .frame(width: 36, height: 36)
                        .background(habit.color.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(BlazeTheme.textPrimary)

                        HStack(spacing: 16) {
                            Label("\(habit.currentStreak) current", systemImage: "flame.fill")
                            Label("\(habit.longestStreak) best", systemImage: "trophy.fill")
                            Label("\(habit.totalCompletions) total", systemImage: "checkmark")
                        }
                        .font(.caption)
                        .foregroundStyle(BlazeTheme.textSecondary)
                    }

                    Spacer()

                    // Streak badge
                    if habit.currentStreak >= 3 {
                        HStack(spacing: 2) {
                            FlameIcon(isAnimating: true)
                                .frame(width: 14, height: 14)
                            Text("\(habit.currentStreak)")
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .foregroundStyle(BlazeTheme.streak)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(BlazeTheme.streak.opacity(0.15), in: Capsule())
                    }
                }
                .padding(12)
                .background(BlazeTheme.surface, in: RoundedRectangle(cornerRadius: BlazeTheme.cardRadius))
            }

            // Weekly heatmap
            if !habits.isEmpty {
                weeklyGrid
            }
        }
    }

    private var weeklyGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 7 Days")
                .font(.headline)
                .foregroundStyle(BlazeTheme.textPrimary)
                .padding(.top, 8)

            let calendar = Calendar.current
            let today = calendar.startOfDay(for: .now)
            let days = (0..<7).reversed().map { calendar.date(byAdding: .day, value: -$0, to: today)! }

            HStack(spacing: 6) {
                ForEach(days, id: \.self) { day in
                    let completedCount = habits.filter { habit in
                        habit.completions.contains { calendar.startOfDay(for: $0.date) == day }
                    }.count

                    let ratio = habits.isEmpty ? 0.0 : Double(completedCount) / Double(habits.count)

                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(ratio > 0 ? BlazeTheme.accent.opacity(0.3 + ratio * 0.7) : BlazeTheme.surfaceLight)
                            .frame(height: 32)

                        Text(day.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                            .foregroundStyle(
                                calendar.isDateInToday(day) ? BlazeTheme.accent : BlazeTheme.textSecondary
                            )
                    }
                }
            }
        }
        .padding(14)
        .background(BlazeTheme.surface, in: RoundedRectangle(cornerRadius: BlazeTheme.cardRadius))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: BlazeTheme.iconWeight))
                .foregroundStyle(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(BlazeTheme.textPrimary)

            Text(title)
                .font(.caption2)
                .foregroundStyle(BlazeTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(BlazeTheme.surface, in: RoundedRectangle(cornerRadius: BlazeTheme.cardRadius))
    }
}
