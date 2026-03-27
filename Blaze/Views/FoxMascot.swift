import SwiftUI

struct FoxMascot: View {
    @State private var breatheScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            foxBody
        }
        .scaleEffect(breatheScale)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
            ) {
                breatheScale = 1.05
            }
        }
    }

    private var foxBody: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let cx = w / 2
            let cy = h / 2

            // Left ear
            var leftEar = Path()
            leftEar.move(to: CGPoint(x: cx - 38, y: cy - 30))
            leftEar.addLine(to: CGPoint(x: cx - 52, y: cy - 68))
            leftEar.addLine(to: CGPoint(x: cx - 18, y: cy - 42))
            leftEar.closeSubpath()
            context.fill(leftEar, with: .color(Color(hex: "FF6B35")))

            // Left ear inner
            var leftEarInner = Path()
            leftEarInner.move(to: CGPoint(x: cx - 36, y: cy - 34))
            leftEarInner.addLine(to: CGPoint(x: cx - 46, y: cy - 58))
            leftEarInner.addLine(to: CGPoint(x: cx - 22, y: cy - 42))
            leftEarInner.closeSubpath()
            context.fill(leftEarInner, with: .color(Color(hex: "FFB088")))

            // Right ear
            var rightEar = Path()
            rightEar.move(to: CGPoint(x: cx + 38, y: cy - 30))
            rightEar.addLine(to: CGPoint(x: cx + 52, y: cy - 68))
            rightEar.addLine(to: CGPoint(x: cx + 18, y: cy - 42))
            rightEar.closeSubpath()
            context.fill(rightEar, with: .color(Color(hex: "FF6B35")))

            // Right ear inner
            var rightEarInner = Path()
            rightEarInner.move(to: CGPoint(x: cx + 36, y: cy - 34))
            rightEarInner.addLine(to: CGPoint(x: cx + 46, y: cy - 58))
            rightEarInner.addLine(to: CGPoint(x: cx + 22, y: cy - 42))
            rightEarInner.closeSubpath()
            context.fill(rightEarInner, with: .color(Color(hex: "FFB088")))

            // Head
            let headRect = CGRect(x: cx - 45, y: cy - 40, width: 90, height: 75)
            let headPath = Path(roundedRect: headRect, cornerRadius: 35)
            context.fill(headPath, with: .color(Color(hex: "FF6B35")))

            // Face mask (white area)
            var faceMask = Path()
            faceMask.move(to: CGPoint(x: cx - 28, y: cy - 10))
            faceMask.addQuadCurve(
                to: CGPoint(x: cx, y: cy + 30),
                control: CGPoint(x: cx - 30, y: cy + 25)
            )
            faceMask.addQuadCurve(
                to: CGPoint(x: cx + 28, y: cy - 10),
                control: CGPoint(x: cx + 30, y: cy + 25)
            )
            faceMask.addQuadCurve(
                to: CGPoint(x: cx - 28, y: cy - 10),
                control: CGPoint(x: cx, y: cy - 18)
            )
            faceMask.closeSubpath()
            context.fill(faceMask, with: .color(Color(hex: "FFF5EB")))

            // Left eye
            let leftEyeRect = CGRect(x: cx - 22, y: cy - 12, width: 10, height: 12)
            let leftEyePath = Path(ellipseIn: leftEyeRect)
            context.fill(leftEyePath, with: .color(Color(hex: "2D1B0E")))

            // Left eye shine
            let leftShine = CGRect(x: cx - 19, y: cy - 10, width: 4, height: 4)
            context.fill(Path(ellipseIn: leftShine), with: .color(.white))

            // Right eye
            let rightEyeRect = CGRect(x: cx + 12, y: cy - 12, width: 10, height: 12)
            let rightEyePath = Path(ellipseIn: rightEyeRect)
            context.fill(rightEyePath, with: .color(Color(hex: "2D1B0E")))

            // Right eye shine
            let rightShine = CGRect(x: cx + 15, y: cy - 10, width: 4, height: 4)
            context.fill(Path(ellipseIn: rightShine), with: .color(.white))

            // Nose
            var nose = Path()
            nose.move(to: CGPoint(x: cx - 5, y: cy + 8))
            nose.addLine(to: CGPoint(x: cx + 5, y: cy + 8))
            nose.addLine(to: CGPoint(x: cx, y: cy + 14))
            nose.closeSubpath()
            context.fill(nose, with: .color(Color(hex: "2D1B0E")))

            // Mouth
            var mouth = Path()
            mouth.move(to: CGPoint(x: cx, y: cy + 14))
            mouth.addQuadCurve(
                to: CGPoint(x: cx - 8, y: cy + 18),
                control: CGPoint(x: cx - 5, y: cy + 18)
            )
            mouth.move(to: CGPoint(x: cx, y: cy + 14))
            mouth.addQuadCurve(
                to: CGPoint(x: cx + 8, y: cy + 18),
                control: CGPoint(x: cx + 5, y: cy + 18)
            )
            context.stroke(mouth, with: .color(Color(hex: "2D1B0E")), lineWidth: 1.5)

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

            // Tail
            var tail = Path()
            tail.move(to: CGPoint(x: cx + 28, y: cy + 60))
            tail.addQuadCurve(
                to: CGPoint(x: cx + 65, y: cy + 40),
                control: CGPoint(x: cx + 55, y: cy + 65)
            )
            tail.addQuadCurve(
                to: CGPoint(x: cx + 55, y: cy + 55),
                control: CGPoint(x: cx + 68, y: cy + 45)
            )
            tail.closeSubpath()
            context.fill(tail, with: .color(Color(hex: "FF6B35")))

            // Tail tip
            var tailTip = Path()
            tailTip.move(to: CGPoint(x: cx + 58, y: cy + 42))
            tailTip.addQuadCurve(
                to: CGPoint(x: cx + 65, y: cy + 40),
                control: CGPoint(x: cx + 62, y: cy + 38)
            )
            tailTip.addQuadCurve(
                to: CGPoint(x: cx + 55, y: cy + 50),
                control: CGPoint(x: cx + 65, y: cy + 48)
            )
            tailTip.closeSubpath()
            context.fill(tailTip, with: .color(.white))
        }
    }
}
