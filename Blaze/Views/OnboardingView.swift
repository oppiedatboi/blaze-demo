import SwiftUI
import UIKit

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    @State private var dragOffset: CGFloat = 0
    @State private var showElements: [Bool] = [false, false, false]

    private let pages: [(mascot: AnyView, title: String, subtitle: String)] = [
        (
            AnyView(FoxMascotWaving()),
            "Track Your Habits",
            "Build daily routines and watch\nyour streaks grow over time"
        ),
        (
            AnyView(FoxMascotFlame()),
            "Build Streaks",
            "Stay consistent and keep your\nfire burning every single day"
        ),
        (
            AnyView(FoxMascotCelebrating()),
            "Stay on Fire",
            "Widgets, reminders, and celebrations\nto keep you motivated"
        ),
    ]

    var body: some View {
        ZStack {
            BlazeTheme.background.ignoresSafeArea()

            GeometryReader { geo in
                let width = geo.size.width

                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { index in
                        pageContent(index: index, width: width)
                            .frame(width: width)
                    }
                }
                .offset(x: -CGFloat(currentPage) * width + dragOffset)
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: currentPage)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            let velocity = value.predictedEndTranslation.width - value.translation.width
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                if value.translation.width < -threshold || velocity < -100 {
                                    currentPage = min(currentPage + 1, 2)
                                } else if value.translation.width > threshold || velocity > 100 {
                                    currentPage = max(currentPage - 1, 0)
                                }
                                dragOffset = 0
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            triggerPageAnimation()
                        }
                )
            }

            // Bottom controls
            VStack {
                Spacer()

                // Page dots
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? BlazeTheme.accent : BlazeTheme.surfaceLight)
                            .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.bottom, 20)

                // CTA Button
                Button {
                    if currentPage < 2 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            currentPage += 1
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        triggerPageAnimation()
                    } else {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            hasSeenOnboarding = true
                        }
                    }
                } label: {
                    Text(currentPage == 2 ? "Get Started" : "Continue")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(BlazeTheme.accent, in: Capsule())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .scaleEffect(showElements[currentPage] ? 1.0 : 0.9)
                .opacity(showElements[currentPage] ? 1.0 : 0.0)
                .offset(y: showElements[currentPage] ? 0 : 20)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5), value: showElements[currentPage])
            }
        }
        .onAppear {
            triggerPageAnimation()
        }
    }

    @ViewBuilder
    private func pageContent(index: Int, width: CGFloat) -> some View {
        VStack(spacing: 28) {
            Spacer()

            pages[index].mascot
                .frame(width: 200, height: 200)
                .scaleEffect(showElements[index] ? 1.0 : 0.8)
                .opacity(showElements[index] ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showElements[index])

            Text(pages[index].title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(BlazeTheme.textPrimary)
                .opacity(showElements[index] ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: showElements[index])

            Text(pages[index].subtitle)
                .font(.body)
                .foregroundStyle(BlazeTheme.textSecondary)
                .multilineTextAlignment(.center)
                .opacity(showElements[index] ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.35), value: showElements[index])

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }

    private func triggerPageAnimation() {
        // Reset current page animation
        showElements[currentPage] = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            showElements[currentPage] = true
        }
    }
}
