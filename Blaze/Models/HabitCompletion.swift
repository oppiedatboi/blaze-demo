import Foundation
import SwiftData

@Model
final class HabitCompletion {
    var date: Date
    var habit: Habit?

    init(date: Date, habit: Habit) {
        self.date = date
        self.habit = habit
    }
}
