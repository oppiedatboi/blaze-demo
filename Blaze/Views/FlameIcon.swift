import SwiftUI

struct FlameIcon: View {
    var isAnimating: Bool

    @State private var pulseScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.4

    var body: some View {
        ZStack {
            if isAnimating {
                Image(systemName: "flame.fill")
                    .font(.system(size: 12, weight: BlazeTheme.iconWeight))
                    .foregroundStyle(BlazeTheme.streak.opacity(glowOpacity))
                    .scaleEffect(pulseScale * 1.4)
                    .blur(radius: 4)
            }

            Image(systemName: "flame.fill")
                .font(.system(size: 12, weight: BlazeTheme.iconWeight))
                .foregroundStyle(BlazeTheme.streak)
                .scaleEffect(isAnimating ? pulseScale : 1.0)
        }
        .onAppear {
            guard isAnimating else { return }
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                pulseScale = 1.2
                glowOpacity = 0.8
            }
        }
    }
}
