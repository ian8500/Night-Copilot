import Foundation

struct MockAIChatService: AIChatService {
    private let builder = PromptBuilder()

    func reply(to userText: String, context: CopilotContext, history: [AIChatMessage]) async throws -> AIChatMessage {
        try await Task.sleep(for: .milliseconds(250))

        // Simulate occasional AI downtime and enforce local fallback from VM
        if userText.lowercased().contains("service down") {
            throw URLError(.cannotConnectToHost)
        }

        var response = builder.buildResponse(userText: userText, context: context)
        let memoryReference = memoryAwareLine(history: history, depth: context.supportDepth)

        if !memoryReference.isEmpty {
            response = AIChatMessage(
                role: .assistant,
                text: response.text + "\n\n" + memoryReference,
                inferredState: response.inferredState,
                handoff: response.handoff
            )
        }

        return response
    }

    private func memoryAwareLine(history: [AIChatMessage], depth: SupportDepthMode) -> String {
        let userTurns = history.filter { $0.role == .user }
        guard let latest = userTurns.last?.text else { return "" }

        switch depth {
        case .quiet:
            return "I’m tracking this with you."
        case .steady:
            return "I’m holding onto what you said most recently: \"\(latest)\"."
        case .deep:
            let previous = userTurns.dropLast().last?.text
            if let previous {
                return "I’m noticing continuity between \"\(previous)\" and \"\(latest)\", which suggests this is a repeating loop tonight."
            }
            return "I’m keeping in-session memory so you don’t need to repeat yourself."
        }
    }
}
