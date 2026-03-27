import WidgetKit
import SwiftUI
import SwiftData

struct BlazeStreakWidget: Widget {
    let kind: String = "BlazeStreakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakProvider()) { entry in
            StreakWidgetView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        colors: [Color(hex: "1A0A00"), Color(hex: "0D0D0D")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    for: .widget
                )
        }
        .configurationDisplayName("Streak Tracker")
        .description("See your habit streaks at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct StreakEntry: TimelineEntry {
    let date: Date
    let habits: [HabitSnapshot]
}

struct HabitSnapshot: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let colorHex: String
    let streak: Int
    let completedToday: Bool
}

struct StreakProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(date: .now, habits: [
            HabitSnapshot(name: "Meditate", icon: "brain.head.profile", colorHex: "FF6B35", streak: 7, completedToday: true),
            HabitSnapshot(name: "Exercise", icon: "figure.run", colorHex: "4CAF50", streak: 3, completedToday: false),
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> Void) {
        let entry = loadEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakEntry>) -> Void) {
        let entry = loadEntry()
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadEntry() -> StreakEntry {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: Habit.self, HabitCompletion.self, configurations: config)
            let context = ModelContext(container)

            let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.createdAt)])
            let habits = try context.fetch(descriptor)

            let snapshots = habits.prefix(4).map { habit in
                HabitSnapshot(
                    name: habit.name,
                    icon: habit.icon,
                    colorHex: habit.colorHex,
                    streak: habit.currentStreak,
                    completedToday: habit.isCompletedToday
                )
            }

            return StreakEntry(date: .now, habits: snapshots)
        } catch {
            return StreakEntry(date: .now, habits: [])
        }
    }
}

struct StreakWidgetView: View {
    let entry: StreakEntry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        default:
            smallWidget
        }
    }

    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(hex: "FF6B35"))
                    Text("Blaze")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }

                Spacer()

                // Mini fox head
                ZStack {
                    Circle()
                        .fill(Color(hex: "FF6B35"))
                        .frame(width: 18, height: 18)
                    Circle()
                        .fill(Color(hex: "FFF5EB"))
                        .frame(width: 10, height: 8)
                        .offset(y: 2)
                    // Eyes
                    HStack(spacing: 4) {
                        Circle().fill(Color(hex: "2D1B0E")).frame(width: 2.5, height: 2.5)
                        Circle().fill(Color(hex: "2D1B0E")).frame(width: 2.5, height: 2.5)
                    }
                    .offset(y: 0)
                }
            }

            if entry.habits.isEmpty {
                Spacer()
                Text("Add habits\nto get started")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
            } else {
                Spacer()
                ForEach(entry.habits.prefix(3)) { habit in
                    HStack(spacing: 6) {
                        Image(systemName: habit.icon)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color(hex: habit.colorHex))

                        Text("\(habit.streak)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "FF9F1C"))

                        if habit.completedToday {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 8))
                                .foregroundStyle(Color(hex: "4CAF50"))
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color(hex: "FF6B35").opacity(0.3), Color(hex: "FF9F1C").opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
                .padding(-16)
        )
    }

    private var mediumWidget: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "FF6B35"))
                Text("Blaze")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Spacer()
                Text(entry.date.formatted(.dateTime.weekday(.wide)))
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }

            if entry.habits.isEmpty {
                HStack {
                    Spacer()
                    Text("Add habits to track your streaks")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    Spacer()
                }
                .padding(.vertical, 8)
            } else {
                HStack(spacing: 12) {
                    ForEach(entry.habits.prefix(4)) { habit in
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: habit.colorHex).opacity(0.15))
                                    .frame(width: 36, height: 36)

                                Image(systemName: habit.icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Color(hex: habit.colorHex))
                            }

                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 8))
                                Text("\(habit.streak)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }
                            .foregroundStyle(Color(hex: "FF9F1C"))

                            if habit.completedToday {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color(hex: "4CAF50"))
                            } else {
                                Image(systemName: "circle")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.3))
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color(hex: "FF6B35").opacity(0.3), Color(hex: "FF9F1C").opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
                .padding(-16)
        )
    }
}
