import SwiftUI
import UIKit

struct VoiceInputOverlay: View {
    @Binding var isPresented: Bool
    @Binding var text: String
    let onComplete: () -> Void

    @State private var overlayScale: CGFloat = 0.0
    @State private var micPulse: CGFloat = 1.0
    @State private var showCheckmark = false
    @State private var iconRotation: Double = 0

    var body: some View {
        ZStack {
            // Dark overlay
            Circle()
                .fill(Color.black.opacity(0.85))
                .scaleEffect(overlayScale * 3)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // Pulsing mic / checkmark
                ZStack {
                    if !showCheckmark {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 48, weight: .medium))
                            .foregroundStyle(BlazeTheme.accent)
                            .scaleEffect(micPulse)
                            .rotation3DEffect(.degrees(iconRotation), axis: (x: 0, y: 1, z: 0))
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48, weight: .medium))
                            .foregroundStyle(BlazeTheme.success)
                            .rotation3DEffect(.degrees(iconRotation - 360), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .frame(width: 80, height: 80)
                .background(BlazeTheme.surface, in: Circle())

                Text(showCheckmark ? "Got it!" : "Listening...")
                    .font(.headline)
                    .foregroundStyle(BlazeTheme.textPrimary)

                if !showCheckmark {
                    // Animated dots
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .fill(BlazeTheme.accent)
                                .frame(width: 8, height: 8)
                                .scaleEffect(micPulse)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.2),
                                    value: micPulse
                                )
                        }
                    }
                }
            }
            .opacity(overlayScale > 0.3 ? 1.0 : 0.0)
        }
        .onAppear {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                overlayScale = 1.0
            }
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                micPulse = 1.15
            }

            // Simulate "recording" for 1.5s then complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                withAnimation(.easeInOut(duration: 0.4)) {
                    iconRotation = 360
                    showCheckmark = true
                }
                text = "Morning Run"

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        overlayScale = 0.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isPresented = false
                        onComplete()
                    }
                }
            }
        }
    }
}
