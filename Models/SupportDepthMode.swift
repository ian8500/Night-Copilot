import Foundation

enum SupportDepthMode: String, CaseIterable, Identifiable, Codable {
    case quiet
    case steady
    case deep

    var id: String { rawValue }

    var title: String {
        switch self {
        case .quiet: return "Quiet"
        case .steady: return "Steady"
        case .deep: return "Deep"
        }
    }

    var subtitle: String {
        switch self {
        case .quiet: return "Shortest possible guidance"
        case .steady: return "Balanced support"
        case .deep: return "Richer reflection + structure"
        }
    }
}
