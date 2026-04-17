import Foundation

enum ResetTool: String, CaseIterable, Identifiable, Codable {
    case reset60
    case breathing1m
    case quiet5m
    case windDown10m

    var id: String { rawValue }

    var title: String {
        switch self {
        case .reset60:
            return "60-second pause"
        case .breathing1m:
            return "1-minute breath downshift"
        case .quiet5m:
            return "5-minute quiet floor"
        case .windDown10m:
            return "10-minute transition"
        }
    }

    var duration: TimeInterval {
        switch self {
        case .reset60, .breathing1m:
            return 60
        case .quiet5m:
            return 300
        case .windDown10m:
            return 600
        }
    }

    var guidanceText: String {
        switch self {
        case .reset60:
            return "One minute. Reduce input. Lengthen exhale."
        case .breathing1m:
            return "Gentle inhale, longer exhale. Let your shoulders drop."
        case .quiet5m:
            return "No solving. Just five minutes of nervous-system quiet."
        case .windDown10m:
            return "Move from performance mode into recovery mode."
        }
    }
}
