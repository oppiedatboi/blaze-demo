import SwiftUI
import SwiftData

@main
struct BlazeApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView()
                    .preferredColorScheme(.dark)
            }
        }
        .modelContainer(for: [Habit.self, HabitCompletion.self])
    }
}
