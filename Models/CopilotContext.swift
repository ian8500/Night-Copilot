import Foundation

struct CopilotContext {
    var nightState: NightState?
    var currentPrompt: CalmPrompt?
    var supportDepth: SupportDepthMode
    var localeIdentifier: String
    var recentPatternSummary: String?
    var sessionMemory: CopilotSessionMemory

    init(
        nightState: NightState? = nil,
        currentPrompt: CalmPrompt? = nil,
        supportDepth: SupportDepthMode = .steady,
        localeIdentifier: String = Locale.current.identifier,
        recentPatternSummary: String? = nil,
        sessionMemory: CopilotSessionMemory = .init()
    ) {
        self.nightState = nightState
        self.currentPrompt = currentPrompt
        self.supportDepth = supportDepth
        self.localeIdentifier = localeIdentifier
        self.recentPatternSummary = recentPatternSummary
        self.sessionMemory = sessionMemory
    }
}
