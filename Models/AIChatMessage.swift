import Foundation

struct AIChatMessage: Identifiable, Hashable {
    enum Role {
        case user
        case assistant
        case safety
    }

    let id = UUID()
    let role: Role
    let text: String
    let timestamp: Date

    init(role: Role, text: String, timestamp: Date = .now) {
        self.role = role
        self.text = text
        self.timestamp = timestamp
    }
}
