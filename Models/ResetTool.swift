import Foundation

enum ResetTool: String, CaseIterable, Identifiable {
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
            return "1-minute breathing"
        case .quiet5m:
            return "5-minute quiet"
        case .windDown10m:
            return "10-minute wind-down"
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
            return "One minute. Fewer decisions. Slower breathing."
        case .breathing1m:
            return "Inhale gently, exhale longer, and let your shoulders soften."
        case .quiet5m:
            return "No solving for now. Just five quiet minutes to settle."
        case .windDown10m:
            return "Lower stimulation and give your nervous system room to power down."
        }
    }
}
