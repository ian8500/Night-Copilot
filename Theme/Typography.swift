import SwiftUI

enum Typography {
    static let display = Font.system(size: 38, weight: .bold, design: .rounded)
    static let title = Font.system(.largeTitle, design: .rounded).weight(.semibold)
    static let subtitle = Font.system(.body, design: .rounded)
    static let sectionTitle = Font.system(.title3, design: .rounded).weight(.semibold)
    static let sectionLabel = Font.system(.subheadline, design: .rounded).weight(.semibold)
    static let cardTitle = Font.system(.title3, design: .rounded).weight(.semibold)
    static let body = Font.system(.body, design: .rounded)
    static let caption = Font.system(.caption, design: .rounded)
    static let timer = Font.system(size: 58, weight: .bold, design: .rounded)
    static let actionButton = Font.system(.body, design: .rounded).weight(.semibold)
}
