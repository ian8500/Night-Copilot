import Foundation

enum TierAccess: String {
    case free
    case premium

    var label: String {
        switch self {
        case .free:
            return "Free"
        case .premium:
            return "Plus"
        }
    }

    var lockSystemImage: String? {
        switch self {
        case .free:
            return nil
        case .premium:
            return "lock.fill"
        }
    }
}

struct TierFeature: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let tier: TierAccess
}

enum TierCatalog {
    static let freeFeatures: [TierFeature] = [
        .init(title: "Night state plans", detail: "Immediate steps for sleep, stress, and reset moments.", tier: .free),
        .init(title: "Core timers", detail: "60-second, 1-minute, 5-minute, and wind-down tools.", tier: .free),
        .init(title: "Calm Copilot chat", detail: "Short supportive guidance with safety escalation.", tier: .free)
    ]

    static let premiumFeatures: [TierFeature] = [
        .init(title: "Deeper guided sessions", detail: "Longer step-by-step routines for tough nights.", tier: .premium),
        .init(title: "Personalized scripts", detail: "Context-aware grounding scripts tailored to your state.", tier: .premium),
        .init(title: "Progress insights", detail: "Reflective trends and bedtime pattern summaries.", tier: .premium)
    ]
}
