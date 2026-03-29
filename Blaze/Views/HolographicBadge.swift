import SwiftUI
import UIKit

struct HolographicBadge: View {
    let streak: Int
    @State private var dragOffset: CGSize = .zero

    private var gradientCenter: UnitPoint {
        UnitPoint(
            x: 0.5 + dragOffset.width / 200,
            y: 0.5 + dragOffset.height / 200
        )
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .font(.system(size: 10, weight: .bold))
            Text("\(streak)")
                .font(.caption2)
                .fontWeight(.heavy)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    AngularGradient(
                        colors: [
                            Color(hex: "FFD700"),
                            Color(hex: "C0C0C0"),
                            Color(hex: "6B9FFF"),
                            Color(hex: "FF69B4"),
                            Color(hex: "FFD700")
                        ],
                        center: gradientCenter
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .clear,
                                    .white.opacity(0.15)
                                ],
                                startPoint: UnitPoint(
                                    x: 0.3 + dragOffset.width / 300,
                                    y: 0.0
                                ),
                                endPoint: UnitPoint(
                                    x: 0.7 + dragOffset.width / 300,
                                    y: 1.0
                                )
                            )
                        )
                )
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    dragOffset = value.translation
                    UISelectionFeedbackGenerator().selectionChanged()
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        dragOffset = .zero
                    }
                }
        )
    }
}
