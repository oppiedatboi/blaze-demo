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
    static let symbolConfig = Image.SymbolConfiguration(weight: .medium)

    static let cardRadius: CGFloat = 16
    static let smallRadius: CGFloat = 10
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
