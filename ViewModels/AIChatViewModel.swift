import Foundation

@MainActor
final class AIChatViewModel: ObservableObject {
    @Published var messages: [AIChatMessage] = []
    @Published var inputText = ""
    @Published var isSending = false
    @Published var supportDepth: SupportDepthMode
    @Published var isEscalated = false

    let quickReplies = [
        "I feel exhausted but can't switch off",
        "Keep this short",
        "My mind is racing",
        "My body feels tense",
        "I just got off shift and feel wired"
    ]

    private var context: CopilotContext
    private let chatService: AIChatService
    private let fallbackService = LocalFallbackSupportService()
    private let safetyService = SafetyEscalationService()
    private let memoryStore: NightMemoryStore?
    private let builder = PromptBuilder()

    init(
        context: CopilotContext,
        chatService: AIChatService = MockAIChatService(),
        memoryStore: NightMemoryStore? = nil
    ) {
        self.context = context
        self.chatService = chatService
        self.memoryStore = memoryStore
        self.supportDepth = context.supportDepth

        let welcome = "I’m here. I’ll listen first, identify your likely state, and guide one clear next action with a button."
        messages = [AIChatMessage(role: .assistant, text: welcome)]
    }

    func setDepth(_ depth: SupportDepthMode) {
        supportDepth = depth
        context.supportDepth = depth
        memoryStore?.setPreferredDepth(depth)
    }

    func send(_ text: String? = nil) async {
        guard !isEscalated else { return }

        let trimmed = (text ?? inputText).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        inputText = ""
        isSending = true

        let userMessage = AIChatMessage(role: .user, text: trimmed)
        messages.append(userMessage)

        if let escalation = safetyService.escalationMessageIfNeeded(for: trimmed) {
            messages.append(AIChatMessage(role: .safety, text: escalation, handoff: .urgentHelp))
            isEscalated = true
            isSending = false
            return
        }

        context.supportDepth = supportDepth
        context.recentPatternSummary = memoryStore?.patternSummary

        let inferred = builder.inferState(from: trimmed)
        context.sessionMemory.recordInput(trimmed, inferredState: inferred, mode: supportDepth)

        do {
            let reply = try await chatService.reply(to: trimmed, context: context, history: messages)
            messages.append(reply)
            if let handoff = reply.handoff {
                context.sessionMemory.recordAction(handoff)
            }
        } catch {
            let fallback = fallbackService.fallbackResponse(for: context, userText: trimmed)
            messages.append(fallback)
            if let handoff = fallback.handoff {
                context.sessionMemory.recordAction(handoff)
            }
        }

        isSending = false
    }

    func performHandoff(_ action: AIChatMessage.HandoffAction) {
        guard !isEscalated else { return }
        context.sessionMemory.recordAction(action)

        let followUp: String
        switch action {
        case .startTimer:
            followUp = "Start a 2-minute settle timer now"
        case .launchResetFlow:
            followUp = "Guide me through a reset flow"
        case .showGroundingPrompt:
            followUp = "Show me a grounding prompt"
        case .urgentHelp:
            followUp = "I need urgent help options"
        }

        Task {
            await send(followUp)
        }
    }
}
