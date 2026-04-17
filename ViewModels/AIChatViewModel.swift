import Foundation

@MainActor
final class AIChatViewModel: ObservableObject {
    @Published var messages: [AIChatMessage] = []
    @Published var inputText = ""
    @Published var isSending = false
    @Published var supportDepth: SupportDepthMode

    let quickReplies = [
        "Help me settle now",
        "Keep this short",
        "My mind is racing",
        "I woke up alert",
        "Start a reset flow"
    ]

    var nightStateTitle: String {
        context.nightState?.title ?? "General support"
    }

    var supportModeSubtitle: String {
        supportDepth.subtitle
    }

    private var context: CopilotContext
    private let chatService: AIChatService
    private let fallbackService = LocalFallbackSupportService()
    private let safetyService = SafetyEscalationService()
    private let memoryStore: NightMemoryStore?

    init(
        context: CopilotContext,
        chatService: AIChatService = MockAIChatService(),
        memoryStore: NightMemoryStore? = nil
    ) {
        self.context = context
        self.chatService = chatService
        self.memoryStore = memoryStore
        self.supportDepth = context.supportDepth

        let welcome = "I’m here. I’ll listen first, then give one clear next step. Choose Quiet, Steady, or Deep at any time."
        messages = [AIChatMessage(role: .assistant, text: welcome)]
    }

    func setDepth(_ depth: SupportDepthMode) {
        supportDepth = depth
        context.supportDepth = depth
        memoryStore?.setPreferredDepth(depth)
    }

    func send(_ text: String? = nil) async {
        guard !isSending else { return }

        let trimmed = sanitizeInput(text ?? inputText)
        guard !trimmed.isEmpty else { return }

        inputText = ""
        isSending = true
        defer { isSending = false }

        let userMessage = AIChatMessage(role: .user, text: trimmed)
        messages.append(userMessage)

        let locale = Locale(identifier: context.localeIdentifier)
        if let escalation = safetyService.escalationMessageIfNeeded(for: trimmed, locale: locale) {
            messages.append(AIChatMessage(role: .safety, text: escalation, handoff: .urgentHelp))
            return
        }

        context.supportDepth = supportDepth
        context.recentPatternSummary = memoryStore?.patternSummary

        let inferred = PromptBuilder().buildResponse(userText: trimmed, context: context).inferredState
        context.sessionMemory.append(SessionMemoryItem(timestamp: .now, userSummary: trimmed, inferredState: inferred))

        do {
            let reply = try await chatService.reply(to: trimmed, context: context, history: messages)
            messages.append(reply)
        } catch {
            let fallback = fallbackService.fallbackResponse(for: context, userText: trimmed)
            messages.append(fallback)
        }
    }

    private func sanitizeInput(_ value: String) -> String {
        let compact = value
            .replacingOccurrences(of: "\n{3,}", with: "\n\n", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let maxLength = 700
        guard compact.count > maxLength else { return compact }
        return String(compact.prefix(maxLength))
    }
}
