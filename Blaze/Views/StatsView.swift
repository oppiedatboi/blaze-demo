import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showCards = false
    @State private var showHeatmap = false
    @State private var progressValue: CGFloat = 0

    private var todayCompletionRate: CGFloat {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter(\.isCompletedToday).count
        return CGFloat(completed) / CGFloat(habits.count)
    }

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
                            // Progress ring
                            todayProgressRing

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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showCards = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                        progressValue = todayCompletionRate
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showHeatmap = true
                }
            }
        }
    }

    private var todayProgressRing: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(BlazeTheme.surfaceLight, lineWidth: 8)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: progressValue)
                    .stroke(
                        LinearGradient(
                            colors: [BlazeTheme.accent, BlazeTheme.streak],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(Int(todayCompletionRate * 100))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(BlazeTheme.textPrimary)
                        .contentTransition(.numericText())

                    Text("today")
                        .font(.caption2)
                        .foregroundStyle(BlazeTheme.textSecondary)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private var overviewCards: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Total Habits",
                value: habits.count,
                icon: "list.bullet",
                color: BlazeTheme.accent,
                delay: 0
            )
            .scaleEffect(showCards ? 1.0 : 0.9)
            .opacity(showCards ? 1.0 : 0.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0), value: showCards)

            StatCard(
                title: "Completions",
                value: habits.reduce(0) { $0 + $1.totalCompletions },
                icon: "checkmark.circle.fill",
                color: BlazeTheme.success,
                delay: 0.1
            )
            .scaleEffect(showCards ? 1.0 : 0.9)
            .opacity(showCards ? 1.0 : 0.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: showCards)

            StatCard(
                title: "Best Streak",
                value: habits.map(\.longestStreak).max() ?? 0,
                icon: "flame.fill",
                color: BlazeTheme.streak,
                delay: 0.2
            )
            .scaleEffect(showCards ? 1.0 : 0.9)
            .opacity(showCards ? 1.0 : 0.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.2), value: showCards)
        }
    }

    private var habitBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Habit Breakdown")
                .font(.headline)
                .foregroundStyle(BlazeTheme.textPrimary)

            ForEach(Array(habits.enumerated()), id: \.element.id) { index, habit in
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
                            Label {
                                AnimatedNumber(value: habit.currentStreak, font: .caption, color: BlazeTheme.textSecondary)
                            } icon: {
                                Image(systemName: "flame.fill")
                            }
                            Label {
                                AnimatedNumber(value: habit.longestStreak, font: .caption, color: BlazeTheme.textSecondary)
                            } icon: {
                                Image(systemName: "trophy.fill")
                            }
                            Label {
                                AnimatedNumber(value: habit.totalCompletions, font: .caption, color: BlazeTheme.textSecondary)
                            } icon: {
                                Image(systemName: "checkmark")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(BlazeTheme.textSecondary)
                    }

                    Spacer()

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
                .scaleEffect(showCards ? 1.0 : 0.9)
                .opacity(showCards ? 1.0 : 0.0)
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.7).delay(0.3 + Double(index) * 0.1),
                    value: showCards
                )
            }

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
                ForEach(Array(days.enumerated()), id: \.element) { index, day in
                    let completedCount = habits.filter { habit in
                        habit.completions.contains { calendar.startOfDay(for: $0.date) == day }
                    }.count

                    let ratio = habits.isEmpty ? 0.0 : Double(completedCount) / Double(habits.count)

                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(ratio > 0 ? BlazeTheme.accent.opacity(0.3 + ratio * 0.7) : BlazeTheme.surfaceLight)
                            .frame(height: 32)
                            .scaleEffect(y: showHeatmap ? 1.0 : 0.0, anchor: .bottom)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.05),
                                value: showHeatmap
                            )

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
    let value: Int
    let icon: String
    let color: Color
    var delay: Double = 0

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: BlazeTheme.iconWeight))
                .foregroundStyle(color)

            AnimatedNumber(value: value, font: .title2.bold(), color: BlazeTheme.textPrimary)

            Text(title)
                .font(.caption2)
                .foregroundStyle(BlazeTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(BlazeTheme.surface, in: RoundedRectangle(cornerRadius: BlazeTheme.cardRadius))
    }
}
