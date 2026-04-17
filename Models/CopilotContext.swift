import Foundation

struct CopilotContext {
    var nightState: NightState?
    var currentPrompt: CalmPrompt?
    var supportDepth: SupportDepthMode
    var localeIdentifier: String
    var recentPatternSummary: String?
    var sessionMemory: [SessionMemoryItem]

    init(
        nightState: NightState? = nil,
        currentPrompt: CalmPrompt? = nil,
        supportDepth: SupportDepthMode = .steady,
        localeIdentifier: String = Locale.current.identifier,
        recentPatternSummary: String? = nil,
        sessionMemory: [SessionMemoryItem] = []
    ) {
        self.nightState = nightState
        self.currentPrompt = currentPrompt
        self.supportDepth = supportDepth
        self.localeIdentifier = localeIdentifier
        self.recentPatternSummary = recentPatternSummary
        self.sessionMemory = sessionMemory
    }
}

struct SessionMemoryItem: Codable, Hashable {
    let timestamp: Date
    let userSummary: String
    let inferredState: InferredSupportState
}

enum InferredSupportState: String, Codable, Hashable {
    case activated
    case exhausted
    case anxious
    case lowMood
    case physicallyTense
    case recovering
    case mixed
}
