import Foundation

struct MockAIChatService: AIChatService {
    private let builder = PromptBuilder()

    func reply(to userText: String, context: CopilotContext) async -> AIChatMessage {
        try? await Task.sleep(for: .milliseconds(250))
        let response = builder.buildResponse(userText: userText, context: context)
        return AIChatMessage(role: .assistant, text: response)
    }
}
