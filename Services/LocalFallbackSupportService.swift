import Foundation

struct LocalFallbackSupportService {
    func fallbackResponse(for context: CopilotContext, userText: String) -> AIChatMessage {
        let stateLabel = context.nightState?.title ?? "this moment"

        let text = [
            "I’m having a temporary AI connection issue, but I’m still with you.",
            "",
            "Structured local guidance for \(stateLabel):",
            "1) Dim light + silence notifications for 60 seconds.",
            "2) Exhale longer than inhale for 6 breaths.",
            "3) Start a 2-minute settle timer.",
            "",
            "Next step: Tap \"Start 2-minute settle\"."
        ].joined(separator: "\n")

        return AIChatMessage(
            role: .assistant,
            text: text,
            inferredState: .recovering,
            handoff: .startTimer
        )
    }
}
