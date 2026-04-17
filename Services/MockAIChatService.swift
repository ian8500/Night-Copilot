import Foundation

struct MockAIChatService: AIChatService {
    private let builder = PromptBuilder()

    func reply(to userText: String, context: CopilotContext, history: [AIChatMessage]) async throws -> AIChatMessage {
        try await Task.sleep(for: .milliseconds(250))

        if userText.lowercased().contains("service down") {
            throw URLError(.cannotConnectToHost)
        }

        let response = builder.buildResponse(userText: userText, context: context)
        let listeningCue = listeningMemoryLine(context: context)

        return AIChatMessage(
            role: .assistant,
            text: response.text + "\n\n" + listeningCue,
            inferredState: response.inferredState,
            handoff: response.handoff
        )
    }

    private func listeningMemoryLine(context: CopilotContext) -> String {
        let memory = context.sessionMemory.recentInputSummaries.suffix(3)
        guard !memory.isEmpty else {
            return "I’m listening in real time and adapting as we go."
        }

        let condensed = memory.joined(separator: " • ")
        switch context.supportDepth {
        case .quiet:
            return "Tracking: \(condensed)."
        case .steady:
            return "What I’m tracking from this session: \(condensed)."
        case .deep:
            return "Session pattern I’m following: \(condensed). I’ll avoid repeating the same intervention if it isn’t helping."
        }
    }
}
