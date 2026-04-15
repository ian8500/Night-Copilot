import SwiftUI

extension Color {
    static let nightBackgroundTop = Color(red: 0.06, green: 0.08, blue: 0.15)
    static let nightBackgroundBottom = Color(red: 0.02, green: 0.03, blue: 0.07)

    static let cardBackground = Color(red: 0.11, green: 0.13, blue: 0.21)
    static let elevatedCardBackground = Color(red: 0.14, green: 0.17, blue: 0.26)
    static let cardStroke = Color.white.opacity(0.12)

    static let mutedIndigo = Color(red: 0.45, green: 0.49, blue: 0.9)
    static let accentGlow = Color(red: 0.52, green: 0.63, blue: 1.0)

    static let secondaryText = Color.white.opacity(0.74)
    static let tertiaryText = Color.white.opacity(0.58)

    static let assistantBubble = Color(red: 0.14, green: 0.17, blue: 0.27)
    static let userBubble = Color(red: 0.27, green: 0.31, blue: 0.6)
    static let safetyBubble = Color(red: 0.45, green: 0.17, blue: 0.18)
}

extension LinearGradient {
    static let appBackground = LinearGradient(
        colors: [.nightBackgroundTop, .nightBackgroundBottom],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGlow = LinearGradient(
        colors: [Color.accentGlow.opacity(0.35), Color.clear],
        startPoint: .top,
        endPoint: .bottom
    )
}
