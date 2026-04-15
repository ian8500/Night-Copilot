import SwiftUI

enum Typography {
    static let title = Font.system(.largeTitle, design: .rounded).weight(.semibold)
    static let subtitle = Font.system(.body, design: .rounded)
    static let cardTitle = Font.system(.title3, design: .rounded).weight(.semibold)
    static let body = Font.system(.body, design: .rounded)
    static let caption = Font.system(.caption, design: .rounded)
    static let timer = Font.system(size: 54, weight: .semibold, design: .rounded)
}
