import Foundation
import SwiftData

@Model
final class Habit {
    var name: String
    var icon: String
    var colorHex: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade, inverse: \HabitCompletion.habit)
    var completions: [HabitCompletion]

    init(name: String, icon: String, colorHex: String = "FF6B35") {
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.createdAt = .now
        self.completions = []
    }

    var color: Color {
        Color(hex: colorHex)
    }

    var currentStreak: Int {
        let calendar = Calendar.current
        let sortedDates = completions
            .map { calendar.startOfDay(for: $0.date) }
            .sorted(by: >)

        guard let first = sortedDates.first else { return 0 }

        let today = calendar.startOfDay(for: .now)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        guard first == today || first == yesterday else { return 0 }

        var streak = 1
        var previousDate = first

        for date in sortedDates.dropFirst() {
            let expected = calendar.date(byAdding: .day, value: -1, to: previousDate)!
            if date == expected {
                streak += 1
                previousDate = date
            } else if date < expected {
                break
            }
        }

        return streak
    }

    var isCompletedToday: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return completions.contains { calendar.startOfDay(for: $0.date) == today }
    }

    func toggleToday(context: ModelContext) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        if let existing = completions.first(where: { calendar.startOfDay(for: $0.date) == today }) {
            context.delete(existing)
        } else {
            let completion = HabitCompletion(date: .now, habit: self)
            context.insert(completion)
        }
    }

    var totalCompletions: Int {
        completions.count
    }

    var longestStreak: Int {
        let calendar = Calendar.current
        let sortedDates = Array(Set(completions.map { calendar.startOfDay(for: $0.date) })).sorted()

        guard !sortedDates.isEmpty else { return 0 }

        var longest = 1
        var current = 1

        for i in 1..<sortedDates.count {
            let expected = calendar.date(byAdding: .day, value: 1, to: sortedDates[i - 1])!
            if sortedDates[i] == expected {
                current += 1
                longest = max(longest, current)
            } else {
                current = 1
            }
        }

        return longest
    }
}

import SwiftUI
