import SwiftUI

struct AnimatedNumber: View {
    let value: Int
    let font: Font
    let color: Color

    @State private var displayedValue: Int = 0
    @State private var bounceScale: CGFloat = 1.0

    init(value: Int, font: Font = .title2.bold(), color: Color = BlazeTheme.textPrimary) {
        self.value = value
        self.font = font
        self.color = color
    }

    var body: some View {
        Text("\(displayedValue)")
            .font(font)
            .foregroundStyle(color)
            .contentTransition(.numericText())
            .scaleEffect(bounceScale)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    displayedValue = value
                }
            }
            .onChange(of: value) { _, newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    displayedValue = newValue
                    bounceScale = 1.1
                }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.15)) {
                    bounceScale = 1.0
                }
            }
    }
}
