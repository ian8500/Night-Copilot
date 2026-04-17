import Foundation

struct AIChatMessage: Identifiable, Hashable {
    enum Role {
        case user
        case assistant
        case safety
        case system
    }

    enum HandoffAction: String, Codable, Hashable {
        case startTimer = "Start 2-minute settle"
        case launchResetFlow = "Open reset flow"
        case showGroundingPrompt = "Open grounding prompt"
        case urgentHelp = "Urgent help now"
    }

    let id = UUID()
    let role: Role
    let text: String
    let timestamp: Date
    let inferredState: InferredSupportState?
    let handoff: HandoffAction?

    init(
        role: Role,
        text: String,
        timestamp: Date = .now,
        inferredState: InferredSupportState? = nil,
        handoff: HandoffAction? = nil
    ) {
        self.role = role
        self.text = text
        self.timestamp = timestamp
        self.inferredState = inferredState
        self.handoff = handoff
    }
}
