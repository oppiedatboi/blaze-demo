import SwiftUI

struct FoxMascot: View {
    @State private var breatheScale: CGFloat = 1.0
    @State private var earWiggle: Double = 0.0

    var body: some View {
        ZStack {
            foxBody
        }
        .scaleEffect(breatheScale)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.5)
                .repeatForever(autoreverses: true)
            ) {
                breatheScale = 1.03
            }
            withAnimation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
                .delay(0.5)
            ) {
                earWiggle = 1.0
            }
        }
    }

    private var foxBody: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let cx = w / 2
            let cy = h / 2

            // Left ear (fluffy, curved)
            var leftEar = Path()
            leftEar.move(to: CGPoint(x: cx - 36, y: cy - 28))
            leftEar.addQuadCurve(
                to: CGPoint(x: cx - 48, y: cy - 66),
                control: CGPoint(x: cx - 52, y: cy - 42)
            )
            leftEar.addQuadCurve(
                to: CGPoint(x: cx - 16, y: cy - 40),
                control: CGPoint(x: cx - 30, y: cy - 68)
            )
            leftEar.closeSubpath()
            context.fill(leftEar, with: .color(Color(hex: "FF6B35")))

            // Left ear inner
            var leftEarInner = Path()
            leftEarInner.move(to: CGPoint(x: cx - 34, y: cy - 32))
            leftEarInner.addQuadCurve(
                to: CGPoint(x: cx - 44, y: cy - 56),
                control: CGPoint(x: cx - 46, y: cy - 40)
            )
            leftEarInner.addQuadCurve(
                to: CGPoint(x: cx - 20, y: cy - 40),
                control: CGPoint(x: cx - 30, y: cy - 58)
            )
            leftEarInner.closeSubpath()
            context.fill(leftEarInner, with: .color(Color(hex: "FFB088")))

            // Left ear fluffy tip
            let leftTipRect = CGRect(x: cx - 52, y: cy - 70, width: 10, height: 8)
            context.fill(Path(ellipseIn: leftTipRect), with: .color(Color(hex: "FFF5EB")))

            // Right ear (fluffy, curved)
            var rightEar = Path()
            rightEar.move(to: CGPoint(x: cx + 36, y: cy - 28))
            rightEar.addQuadCurve(
                to: CGPoint(x: cx + 48, y: cy - 66),
                control: CGPoint(x: cx + 52, y: cy - 42)
            )
            rightEar.addQuadCurve(
                to: CGPoint(x: cx + 16, y: cy - 40),
                control: CGPoint(x: cx + 30, y: cy - 68)
            )
            rightEar.closeSubpath()
            context.fill(rightEar, with: .color(Color(hex: "FF6B35")))

            // Right ear inner
            var rightEarInner = Path()
            rightEarInner.move(to: CGPoint(x: cx + 34, y: cy - 32))
            rightEarInner.addQuadCurve(
                to: CGPoint(x: cx + 44, y: cy - 56),
                control: CGPoint(x: cx + 46, y: cy - 40)
            )
            rightEarInner.addQuadCurve(
                to: CGPoint(x: cx + 20, y: cy - 40),
                control: CGPoint(x: cx + 30, y: cy - 58)
            )
            rightEarInner.closeSubpath()
            context.fill(rightEarInner, with: .color(Color(hex: "FFB088")))

            // Right ear fluffy tip
            let rightTipRect = CGRect(x: cx + 42, y: cy - 70, width: 10, height: 8)
            context.fill(Path(ellipseIn: rightTipRect), with: .color(Color(hex: "FFF5EB")))

            // Head (rounder)
            let headRect = CGRect(x: cx - 46, y: cy - 42, width: 92, height: 78)
            let headPath = Path(roundedRect: headRect, cornerRadius: 40)
            context.fill(headPath, with: .color(Color(hex: "FF6B35")))

            // Face mask (white area — wider, softer)
            var faceMask = Path()
            faceMask.move(to: CGPoint(x: cx - 30, y: cy - 10))
            faceMask.addQuadCurve(
                to: CGPoint(x: cx, y: cy + 32),
                control: CGPoint(x: cx - 32, y: cy + 26)
            )
            faceMask.addQuadCurve(
                to: CGPoint(x: cx + 30, y: cy - 10),
                control: CGPoint(x: cx + 32, y: cy + 26)
            )
            faceMask.addQuadCurve(
                to: CGPoint(x: cx - 30, y: cy - 10),
                control: CGPoint(x: cx, y: cy - 20)
            )
            faceMask.closeSubpath()
            context.fill(faceMask, with: .color(Color(hex: "FFF5EB")))

            // Left blush
            let leftBlush = CGRect(x: cx - 34, y: cy + 4, width: 12, height: 7)
            context.fill(Path(ellipseIn: leftBlush), with: .color(Color(hex: "FFB5B5").opacity(0.5)))

            // Right blush
            let rightBlush = CGRect(x: cx + 22, y: cy + 4, width: 12, height: 7)
            context.fill(Path(ellipseIn: rightBlush), with: .color(Color(hex: "FFB5B5").opacity(0.5)))

            // Left eye (larger, rounder)
            let leftEyeRect = CGRect(x: cx - 24, y: cy - 14, width: 12, height: 14)
            context.fill(Path(ellipseIn: leftEyeRect), with: .color(Color(hex: "2D1B0E")))

            // Left eye shine (bigger)
            let leftShine = CGRect(x: cx - 21, y: cy - 12, width: 5, height: 5)
            context.fill(Path(ellipseIn: leftShine), with: .color(.white))
            let leftShine2 = CGRect(x: cx - 16, y: cy - 6, width: 3, height: 3)
            context.fill(Path(ellipseIn: leftShine2), with: .color(.white.opacity(0.6)))

            // Right eye (larger, rounder)
            let rightEyeRect = CGRect(x: cx + 12, y: cy - 14, width: 12, height: 14)
            context.fill(Path(ellipseIn: rightEyeRect), with: .color(Color(hex: "2D1B0E")))

            // Right eye shine (bigger)
            let rightShine = CGRect(x: cx + 15, y: cy - 12, width: 5, height: 5)
            context.fill(Path(ellipseIn: rightShine), with: .color(.white))
            let rightShine2 = CGRect(x: cx + 20, y: cy - 6, width: 3, height: 3)
            context.fill(Path(ellipseIn: rightShine2), with: .color(.white.opacity(0.6)))

            // Nose
            var nose = Path()
            nose.move(to: CGPoint(x: cx - 5, y: cy + 8))
            nose.addLine(to: CGPoint(x: cx + 5, y: cy + 8))
            nose.addQuadCurve(
                to: CGPoint(x: cx - 5, y: cy + 8),
                control: CGPoint(x: cx, y: cy + 15)
            )
            nose.closeSubpath()
            context.fill(nose, with: .color(Color(hex: "2D1B0E")))

            // Smile (curved, friendly)
            var smile = Path()
            smile.move(to: CGPoint(x: cx - 10, y: cy + 16))
            smile.addQuadCurve(
                to: CGPoint(x: cx, y: cy + 20),
                control: CGPoint(x: cx - 5, y: cy + 22)
            )
            smile.addQuadCurve(
                to: CGPoint(x: cx + 10, y: cy + 16),
                control: CGPoint(x: cx + 5, y: cy + 22)
            )
            context.stroke(smile, with: .color(Color(hex: "2D1B0E")), lineWidth: 1.5)

            // Body
            var body = Path()
            body.move(to: CGPoint(x: cx - 35, y: cy + 32))
            body.addQuadCurve(
                to: CGPoint(x: cx + 35, y: cy + 32),
                control: CGPoint(x: cx, y: cy + 28)
            )
            body.addQuadCurve(
                to: CGPoint(x: cx + 30, y: cy + 72),
                control: CGPoint(x: cx + 40, y: cy + 55)
            )
            body.addQuadCurve(
                to: CGPoint(x: cx - 30, y: cy + 72),
                control: CGPoint(x: cx, y: cy + 78)
            )
            body.addQuadCurve(
                to: CGPoint(x: cx - 35, y: cy + 32),
                control: CGPoint(x: cx - 40, y: cy + 55)
            )
            body.closeSubpath()
            context.fill(body, with: .color(Color(hex: "FF6B35")))

            // Belly
            let bellyRect = CGRect(x: cx - 18, y: cy + 38, width: 36, height: 28)
            context.fill(Path(ellipseIn: bellyRect), with: .color(Color(hex: "FFF5EB")))

            // Tail (thicker, fluffier, more curve)
            var tail = Path()
            tail.move(to: CGPoint(x: cx + 26, y: cy + 58))
            tail.addQuadCurve(
                to: CGPoint(x: cx + 60, y: cy + 32),
                control: CGPoint(x: cx + 55, y: cy + 65)
            )
            tail.addQuadCurve(
                to: CGPoint(x: cx + 70, y: cy + 38),
                control: CGPoint(x: cx + 70, y: cy + 30)
            )
            tail.addQuadCurve(
                to: CGPoint(x: cx + 50, y: cy + 58),
                control: CGPoint(x: cx + 68, y: cy + 52)
            )
            tail.closeSubpath()
            context.fill(tail, with: .color(Color(hex: "FF6B35")))

            // Tail tip (white, fluffy)
            var tailTip = Path()
            tailTip.move(to: CGPoint(x: cx + 60, y: cy + 34))
            tailTip.addQuadCurve(
                to: CGPoint(x: cx + 70, y: cy + 38),
                control: CGPoint(x: cx + 68, y: cy + 30)
            )
            tailTip.addQuadCurve(
                to: CGPoint(x: cx + 58, y: cy + 48),
                control: CGPoint(x: cx + 70, y: cy + 48)
            )
            tailTip.closeSubpath()
            context.fill(tailTip, with: .color(.white))
        }
    }
}

// MARK: - Fox Mascot Waving (for onboarding)
struct FoxMascotWaving: View {
    @State private var waveAngle: Double = 0

    var body: some View {
        ZStack {
            FoxMascot()

            // Waving arm overlay
            Canvas { context, size in
                let cx = size.width / 2
                let cy = size.height / 2

                // Left arm waving
                var arm = Path()
                arm.move(to: CGPoint(x: cx - 38, y: cy + 44))
                arm.addQuadCurve(
                    to: CGPoint(x: cx - 62, y: cy + 16),
                    control: CGPoint(x: cx - 56, y: cy + 32)
                )
                arm.addQuadCurve(
                    to: CGPoint(x: cx - 54, y: cy + 12),
                    control: CGPoint(x: cx - 60, y: cy + 10)
                )
                arm.addQuadCurve(
                    to: CGPoint(x: cx - 34, y: cy + 40),
                    control: CGPoint(x: cx - 48, y: cy + 28)
                )
                arm.closeSubpath()
                context.fill(arm, with: .color(Color(hex: "FF6B35")))

                // Paw
                let pawRect = CGRect(x: cx - 66, y: cy + 8, width: 12, height: 10)
                context.fill(Path(ellipseIn: pawRect), with: .color(Color(hex: "FFF5EB")))
            }
            .rotationEffect(.degrees(waveAngle), anchor: UnitPoint(x: 0.3, y: 0.6))
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.5)
                .repeatForever(autoreverses: true)
            ) {
                waveAngle = 12
            }
        }
    }
}

// MARK: - Fox Mascot with Flame (for onboarding)
struct FoxMascotFlame: View {
    @State private var flameScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            FoxMascot()

            // Flame held above head
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

// MARK: - Fox Mascot Celebrating (for onboarding)
struct FoxMascotCelebrating: View {
    @State private var bounceY: CGFloat = 0
    @State private var starScale: CGFloat = 0.5

    var body: some View {
        ZStack {
            FoxMascot()
                .offset(y: bounceY)

            // Stars around fox
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
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true)
            ) {
                bounceY = -6
            }
            withAnimation(
                .spring(response: 0.5, dampingFraction: 0.5)
            ) {
                starScale = 1.0
            }
        }
    }
}
