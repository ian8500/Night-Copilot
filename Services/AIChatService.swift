import Foundation

protocol AIChatService {
    func reply(to userText: String, context: CopilotContext, history: [AIChatMessage]) async throws -> AIChatMessage
}
