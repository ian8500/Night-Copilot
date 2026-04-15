import Foundation

@MainActor
final class AIChatViewModel: ObservableObject {
    @Published var messages: [AIChatMessage] = []
    @Published var inputText = ""
    @Published var isSending = false

    let quickReplies = [
        "What’s the next best step?",
        "Keep this very short",
        "I need something calming",
        "What if this doesn’t help?",
        "Start a reset timer"
    ]

    private let context: CopilotContext
    private let chatService: AIChatService
    private let safetyService = SafetyEscalationService()

    init(context: CopilotContext, chatService: AIChatService = MockAIChatService()) {
        self.context = context
        self.chatService = chatService

        let welcome = "I’m here with calm, practical support. Tell me what feels hardest right now, and we’ll take one step at a time."
        messages = [AIChatMessage(role: .assistant, text: welcome)]
    }

    func send(_ text: String? = nil) async {
        let trimmed = (text ?? inputText).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        inputText = ""
        isSending = true
        messages.append(AIChatMessage(role: .user, text: trimmed))

        if let escalation = safetyService.escalationMessageIfNeeded(for: trimmed) {
            messages.append(AIChatMessage(role: .safety, text: escalation))
            isSending = false
            return
        }

        let reply = await chatService.reply(to: trimmed, context: context)
        messages.append(reply)
        isSending = false
    }
}
