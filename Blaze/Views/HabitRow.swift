import SwiftUI
import UIKit

struct HabitRow: View {
    let habit: Habit
    let onToggle: () -> Void
    var onDelete: (() -> Void)?

    @State private var completionScale: CGFloat = 1.0
    @State private var checkmarkScale: CGFloat = 1.0
    @State private var checkmarkOpacity: Double = 0
    @State private var backgroundFlash: Double = 0
    @State private var tiltX: CGFloat = 0
    @State private var tiltY: CGFloat = 0
    @State private var isDeleting = false

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

                        AnimatedNumber(
                            value: habit.currentStreak,
                            font: .caption,
                            color: BlazeTheme.streak
                        )

                        Text("day streak")
                            .font(.caption)
                            .foregroundStyle(BlazeTheme.streak)
                    }
                }
            }

            Spacer()

            Button {
                let wasCompleted = isCompleted
                if wasCompleted {
                    // Un-completion
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        completionScale = 0.9
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            completionScale = 1.0
                            checkmarkOpacity = 0
                            checkmarkScale = 0.5
                        }
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } else {
                    // Completion
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        completionScale = 1.3
                        checkmarkOpacity = 1.0
                        checkmarkScale = 1.0
                        backgroundFlash = 0.15
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            completionScale = 1.0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            backgroundFlash = 0
                        }
                    }
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
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
                            .scaleEffect(checkmarkScale)
                            .opacity(checkmarkOpacity)
                    }
                }
                .scaleEffect(completionScale)
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: BlazeTheme.cardRadius)
                .fill(BlazeTheme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: BlazeTheme.cardRadius)
                        .fill(Color.white.opacity(backgroundFlash))
                )
        )
        .shadow(color: BlazeTheme.cardShadowColor, radius: BlazeTheme.cardShadowRadius, y: BlazeTheme.cardShadowY)
        .rotation3DEffect(
            .degrees(Double(tiltY) * 8),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .rotation3DEffect(
            .degrees(Double(-tiltX) * 5),
            axis: (x: 1, y: 0, z: 0),
            perspective: 0.5
        )
        .shadow(
            color: .black.opacity(0.2),
            radius: 8,
            x: -tiltY * 4,
            y: tiltX * 3
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let maxTilt: CGFloat = 1.0
                    tiltX = max(-maxTilt, min(maxTilt, value.translation.height / 80))
                    tiltY = max(-maxTilt, min(maxTilt, value.translation.width / 60))
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                        tiltX = 0
                        tiltY = 0
                    }
                }
        )
        .scaleEffect(isDeleting ? 0.0 : 1.0)
        .opacity(isDeleting ? 0.0 : 1.0)
        .onAppear {
            checkmarkOpacity = isCompleted ? 1.0 : 0.0
            checkmarkScale = isCompleted ? 1.0 : 0.5
        }
    }

    func triggerDelete() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
            isDeleting = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDelete?()
        }
    }
}
