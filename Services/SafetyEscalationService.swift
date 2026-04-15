import Foundation

struct SafetyEscalationService {
    private let escalationKeywords: [String] = [
        "self-harm", "kill myself", "suicide", "can't breathe", "breathing difficulty",
        "chest pain", "danger", "overdose", "emergency", "hurt myself"
    ]

    func escalationMessageIfNeeded(for text: String) -> String? {
        let normalized = text.lowercased()
        let shouldEscalate = escalationKeywords.contains { normalized.contains($0) }

        guard shouldEscalate else { return nil }

        return "I’m really glad you reached out. I can’t provide emergency support, so please contact local emergency services now (911 in the U.S.) or call/text 988 for immediate crisis support. If breathing is difficult or you feel in danger, seek urgent in-person help right away."
    }
}
