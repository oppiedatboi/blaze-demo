import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []

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
                    let rotation = Angle.degrees(elapsed * particle.rotationSpeed)

                    context.opacity = opacity

                    switch particle.shape {
                    case .rectangle:
                        let rect = CGRect(
                            x: x - particle.size / 2,
                            y: y - particle.size / 2,
                            width: particle.size,
                            height: particle.size * 0.6
                        )
                        context.rotate(by: rotation)
                        context.fill(
                            Path(roundedRect: rect, cornerRadius: particle.size * 0.15),
                            with: .color(particle.color)
                        )
                        context.rotate(by: -rotation)

                    case .circle:
                        let rect = CGRect(
                            x: x - particle.size / 2,
                            y: y - particle.size / 2,
                            width: particle.size,
                            height: particle.size
                        )
                        context.fill(Path(ellipseIn: rect), with: .color(particle.color))

                    case .star:
                        let starPath = starShape(
                            center: CGPoint(x: x, y: y),
                            innerRadius: particle.size * 0.3,
                            outerRadius: particle.size * 0.6,
                            points: 5
                        )
                        context.rotate(by: rotation)
                        context.fill(starPath, with: .color(particle.color))
                        context.rotate(by: -rotation)

                    case .ribbon:
                        let rect = CGRect(
                            x: x - particle.size * 0.15,
                            y: y - particle.size,
                            width: particle.size * 0.3,
                            height: particle.size * 1.5
                        )
                        let ribbonRotation = Angle.degrees(sin(elapsed * 4) * 30)
                        context.rotate(by: ribbonRotation)
                        context.fill(
                            Path(roundedRect: rect, cornerRadius: particle.size * 0.1),
                            with: .color(particle.color)
                        )
                        context.rotate(by: -ribbonRotation)
                    }
                }
            }
        }
        .onAppear {
            let now = Date.timeIntervalSinceReferenceDate
            let colors: [Color] = [
                BlazeTheme.accent, BlazeTheme.streak,
                .white, Color(hex: "FF4444"), Color(hex: "FFD700"),
                Color(hex: "FF9F1C"), Color(hex: "4CAF50")
            ]
            let shapes: [ConfettiShape] = [.rectangle, .circle, .star, .ribbon]

            particles = (0..<80).map { _ in
                ConfettiParticle(
                    startX: Double.random(in: 50...350),
                    startY: Double.random(in: -20...100),
                    velocityX: Double.random(in: -120...120),
                    velocityY: Double.random(in: -650 ... -200),
                    size: Double.random(in: 4...12),
                    color: colors.randomElement()!,
                    lifetime: Double.random(in: 1.0...2.0),
                    startTime: now + Double.random(in: 0...0.3),
                    wobbleFreq: Double.random(in: 3...8),
                    wobbleAmp: Double.random(in: 10...30),
                    rotationSpeed: Double.random(in: 60...360),
                    shape: shapes.randomElement()!
                )
            }
        }
    }

    private func starShape(center: CGPoint, innerRadius: Double, outerRadius: Double, points: Int) -> Path {
        var path = Path()
        let angleStep = .pi / Double(points)

        for i in 0..<(points * 2) {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = Double(i) * angleStep - .pi / 2
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

private enum ConfettiShape {
    case rectangle, circle, star, ribbon
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
    let rotationSpeed: Double
    let shape: ConfettiShape
}
