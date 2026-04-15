import SwiftUI

extension Color {
    static let nightBackgroundTop = Color(red: 0.07, green: 0.09, blue: 0.16)
    static let nightBackgroundBottom = Color(red: 0.03, green: 0.04, blue: 0.08)
    static let cardBackground = Color(red: 0.12, green: 0.14, blue: 0.22)
    static let cardStroke = Color.white.opacity(0.10)
    static let mutedIndigo = Color(red: 0.42, green: 0.45, blue: 0.85)
    static let secondaryText = Color.white.opacity(0.74)
}

extension LinearGradient {
    static let appBackground = LinearGradient(
        colors: [.nightBackgroundTop, .nightBackgroundBottom],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
