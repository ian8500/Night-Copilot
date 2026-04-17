import Foundation

struct CopilotSessionMemory: Codable, Hashable {
    private(set) var recentInputs: [SessionMemoryItem] = []
    private(set) var recentActions: [AIChatMessage.HandoffAction] = []
    private static let maxInputs = 5
    private static let maxActions = 5

    mutating func recordInput(_ text: String, inferredState: InferredSupportState, mode: SupportDepthMode) {
        let item = SessionMemoryItem(timestamp: .now, userSummary: text, inferredState: inferredState, responseMode: mode)
        recentInputs.append(item)
        if recentInputs.count > Self.maxInputs {
            recentInputs.removeFirst(recentInputs.count - Self.maxInputs)
        }
    }

    mutating func recordAction(_ action: AIChatMessage.HandoffAction) {
        recentActions.append(action)
        if recentActions.count > Self.maxActions {
            recentActions.removeFirst(recentActions.count - Self.maxActions)
        }
    }

    func wasRecentlySuggested(_ action: AIChatMessage.HandoffAction, within count: Int = 3) -> Bool {
        recentActions.suffix(count).contains(action)
    }

    var recentInputSummaries: [String] {
        recentInputs.map(\.userSummary)
    }
}

struct SessionMemoryItem: Codable, Hashable {
    let timestamp: Date
    let userSummary: String
    let inferredState: InferredSupportState
    let responseMode: SupportDepthMode
}

enum InferredSupportState: String, Codable, Hashable {
    case mindRacing
    case physicalTension
    case emotionalOverwhelm
    case postShiftStimulation
    case insomniaLoop
    case anxious
    case exhausted
    case recovering
    case mixed

    var displayLabel: String {
        switch self {
        case .mindRacing: return "Mind racing"
        case .physicalTension: return "Physical tension"
        case .emotionalOverwhelm: return "Emotional overwhelm"
        case .postShiftStimulation: return "Post-shift stimulation"
        case .insomniaLoop: return "Insomnia loop"
        case .anxious: return "High alert"
        case .exhausted: return "Exhausted"
        case .recovering: return "Recovering"
        case .mixed: return "Mixed state"
        }
    }
}
