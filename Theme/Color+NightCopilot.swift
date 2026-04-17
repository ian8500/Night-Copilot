import SwiftUI

extension Color {
    // Required product palette
    static let nightBackground = Color(hex: 0x0B1020)
    static let nightSurface = Color(hex: 0x121A2F)
    static let primaryAccent = Color(hex: 0x6C7CFF)
    static let secondaryAccent = Color(hex: 0x63D6C8)
    static let glowAccent = Color(hex: 0xA7B4FF)
    static let textPrimary = Color(hex: 0xF5F7FF)
    static let textSecondary = Color(hex: 0xAAB4D6)
    static let safetyAccent = Color(hex: 0xFF8A7A)

    static let cardBackground = nightSurface
    static let elevatedCardBackground = Color(hex: 0x1A2442)
    static let cardStroke = Color.white.opacity(0.08)

    static let assistantBubble = Color(hex: 0x1A2440)
    static let userBubble = Color(hex: 0x2E3B78)
    static let safetyBubble = Color(hex: 0x4A2730)

    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

extension LinearGradient {
    static let appBackground = LinearGradient(
        colors: [
            Color.nightBackground,
            Color(hex: 0x0D1430),
            Color(hex: 0x080C1A)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cinematicGlow = LinearGradient(
        colors: [
            Color.glowAccent.opacity(0.24),
            Color.primaryAccent.opacity(0.08),
            .clear
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
