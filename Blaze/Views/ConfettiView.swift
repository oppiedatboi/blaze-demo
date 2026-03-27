import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var isAnimating = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for particle in particles {
                    let elapsed = now - particle.startTime
                    guard elapsed < particle.lifetime else { continue }

                    let progress = elapsed / particle.lifetime
                    let x = particle.startX + particle.velocityX * elapsed + sin(elapsed * particle.wobbleFreq) * particle.wobbleAmp
                    let y = particle.startY + particle.velocityY * elapsed + 0.5 * 800 * elapsed * elapsed
                    let opacity = 1.0 - progress

                    let rect = CGRect(
                        x: x - particle.size / 2,
                        y: y - particle.size / 2,
                        width: particle.size,
                        height: particle.size
                    )

                    context.opacity = opacity
                    context.fill(
                        Path(roundedRect: rect, cornerRadius: particle.size * 0.2),
                        with: .color(particle.color)
                    )
                }
            }
        }
        .onAppear {
            let now = Date.timeIntervalSinceReferenceDate
            particles = (0..<50).map { _ in
                ConfettiParticle(
                    startX: Double.random(in: 50...350),
                    startY: Double.random(in: -20...100),
                    velocityX: Double.random(in: -100...100),
                    velocityY: Double.random(in: -600 ... -200),
                    size: Double.random(in: 4...10),
                    color: [BlazeTheme.accent, BlazeTheme.streak, .white, Color(hex: "FF4444"), Color(hex: "FFD700")].randomElement()!,
                    lifetime: Double.random(in: 1.0...1.8),
                    startTime: now + Double.random(in: 0...0.3),
                    wobbleFreq: Double.random(in: 3...8),
                    wobbleAmp: Double.random(in: 10...30)
                )
            }
        }
    }
}

private struct ConfettiParticle {
    let startX: Double
    let startY: Double
    let velocityX: Double
    let velocityY: Double
    let size: Double
    let color: Color
    let lifetime: Double
    let startTime: Double
    let wobbleFreq: Double
    let wobbleAmp: Double
}
