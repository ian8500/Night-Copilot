import Foundation

struct LocalFallbackSupportService {
    func fallbackResponse(for context: CopilotContext, userText: String) -> AIChatMessage {
        let stateLabel = context.nightState?.title ?? "this moment"
        let text = "I couldn’t reach full Copilot intelligence right now, but I can still help locally.\n\nFor \(stateLabel):\n1) Lower light and noise for 60 seconds.\n2) Take one longer exhale than inhale.\n3) Start a short reset timer.\n\nNext action: Start timer."
        return AIChatMessage(
            role: .assistant,
            text: text,
            inferredState: .recovering,
            handoff: .startTimer
        )
    }
}
