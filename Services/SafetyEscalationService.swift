import Foundation

struct SafetyEscalationService {
    private let escalationKeywords: [String] = [
        "self-harm", "hurt myself", "kill myself", "end my life", "suicide",
        "overdose", "unresponsive", "can't breathe", "cannot breathe", "trouble breathing",
        "breathing difficulty", "chest pain", "severe distress", "not safe", "unsafe", "emergency"
    ]

    func escalationMessageIfNeeded(for text: String, locale: Locale = .current) -> String? {
        let normalized = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return nil }

        let shouldEscalate = escalationKeywords.contains { normalized.contains($0) }
        guard shouldEscalate else { return nil }

        let region = locale.regionCode ?? "US"
        let emergencyLine: String
        let crisisLine: String

        switch region.uppercased() {
        case "US":
            emergencyLine = "Call 911 now"
            crisisLine = "Call or text 988"
        case "GB":
            emergencyLine = "Call 999 now"
            crisisLine = "Call Samaritans at 116 123"
        case "CA":
            emergencyLine = "Call 911 now"
            crisisLine = "Call or text 988"
        case "AU":
            emergencyLine = "Call 000 now"
            crisisLine = "Call Lifeline at 13 11 14"
        default:
            emergencyLine = "Contact your local emergency number now"
            crisisLine = "Contact your local crisis hotline now"
        }

        return "I can’t assess this safely in chat. If you’re having trouble breathing, feel unsafe, or are at risk, pause chat and \(emergencyLine). If possible, ask someone nearby to stay with you. \(crisisLine)."
    }
}
