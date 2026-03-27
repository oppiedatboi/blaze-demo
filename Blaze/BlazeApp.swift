import SwiftUI
import SwiftData

@main
struct BlazeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [Habit.self, HabitCompletion.self])
    }
}
