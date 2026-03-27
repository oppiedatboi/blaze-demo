import SwiftUI

struct HabitRow: View {
    let habit: Habit
    let onToggle: () -> Void

    @State private var completionScale: CGFloat = 1.0
    @State private var checkmarkOpacity: Double = 0

    private var isCompleted: Bool {
        habit.isCompletedToday
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: habit.icon)
                .font(.system(size: 22, weight: BlazeTheme.iconWeight))
                .foregroundStyle(habit.color)
                .frame(width: 40, height: 40)
                .background(habit.color.opacity(0.15), in: RoundedRectangle(cornerRadius: BlazeTheme.smallRadius))

            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                    .foregroundStyle(BlazeTheme.textPrimary)

                if habit.currentStreak > 0 {
                    HStack(spacing: 4) {
                        FlameIcon(isAnimating: habit.currentStreak >= 3)
                            .frame(width: 14, height: 14)

                        Text("\(habit.currentStreak) day streak")
                            .font(.caption)
                            .foregroundStyle(BlazeTheme.streak)
                    }
                }
            }

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    completionScale = 1.3
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        completionScale = 1.0
                    }
                }
                onToggle()
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(isCompleted ? habit.color : BlazeTheme.surfaceLight, lineWidth: 2.5)
                        .frame(width: 32, height: 32)

                    if isCompleted {
                        Circle()
                            .fill(habit.color)
                            .frame(width: 32, height: 32)

                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .scaleEffect(completionScale)
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(BlazeTheme.surface, in: RoundedRectangle(cornerRadius: BlazeTheme.cardRadius))
    }
}
