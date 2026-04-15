import Foundation

protocol AIChatService {
    func reply(to userText: String, context: CopilotContext) async -> AIChatMessage
}
