import Foundation

struct SafetyEscalationService {
    private let escalationKeywords: [String] = [
        "self-harm", "kill myself", "suicide", "can't breathe", "breathing difficulty",
        "chest pain", "danger", "overdose", "emergency", "hurt myself", "end my life"
    ]

    func escalationMessageIfNeeded(for text: String, locale: Locale = .current) -> String? {
        let normalized = text.lowercased()
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

        return "I’m really glad you reached out. This may be urgent, so pause chat now. \(emergencyLine). If you can, ask someone nearby to stay with you. \(crisisLine)."
    }
}
