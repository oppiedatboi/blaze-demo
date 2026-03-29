import SwiftUI

// V3: Fox mascot types replaced by PitbullMascotView.
// These type aliases exist so the project compiles while all call sites migrate.
// If any reference was missed, it falls back to the pitbull waving pose.

struct FoxMascot: View {
    var body: some View {
        PitbullMascotView(pose: .waving)
    }
}

struct FoxMascotWaving: View {
    var body: some View {
        PitbullMascotView(pose: .waving)
    }
}

struct FoxMascotFlame: View {
    @State private var flameScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            PitbullMascotView(pose: .running)

            Image(systemName: "flame.fill")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FF9F1C"), Color(hex: "FF6B35"), Color(hex: "FF4444")],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .scaleEffect(flameScale)
                .offset(y: -70)
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                flameScale = 1.15
            }
        }
    }
}

struct FoxMascotCelebrating: View {
    @State private var starScale: CGFloat = 0.5

    var body: some View {
        ZStack {
            PitbullMascotView(pose: .celebrating)

            ForEach(0..<5, id: \.self) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: CGFloat.random(in: 8...14)))
                    .foregroundStyle(Color(hex: "FFD700"))
                    .scaleEffect(starScale)
                    .offset(
                        x: CGFloat([-50, 50, -35, 40, 0][i]),
                        y: CGFloat([-60, -55, -30, -25, -75][i])
                    )
            }
        }
        .onAppear {
            withAnimation(
                .spring(response: 0.5, dampingFraction: 0.5)
            ) {
                starScale = 1.0
            }
        }
    }
}
