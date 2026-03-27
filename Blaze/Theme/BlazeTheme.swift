import SwiftUI

enum BlazeTheme {
    static let accent = Color(hex: "FF6B35")
    static let background = Color(hex: "0D0D0D")
    static let surface = Color(hex: "1A1A1A")
    static let surfaceLight = Color(hex: "2A2A2A")
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let streak = Color(hex: "FF9F1C")
    static let success = Color(hex: "4CAF50")

    static let iconWeight: Font.Weight = .medium
    #if canImport(UIKit) && !os(watchOS)
    static let symbolConfig = UIImage.SymbolConfiguration(weight: .medium)
    #endif

    static let cardRadius: CGFloat = 16
    static let smallRadius: CGFloat = 10

    // Gradients
    static let fireGradient = LinearGradient(
        colors: [Color(hex: "FF6B35"), Color(hex: "FF9F1C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let darkGradient = LinearGradient(
        colors: [Color(hex: "1A1A1A"), Color(hex: "0D0D0D")],
        startPoint: .top,
        endPoint: .bottom
    )

    // Shadow
    static let cardShadowColor = Color.black.opacity(0.3)
    static let cardShadowRadius: CGFloat = 8
    static let cardShadowY: CGFloat = 4
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}
