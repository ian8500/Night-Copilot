import Foundation

struct PromptBuilder {
    func buildResponse(userText: String, context: CopilotContext) -> AIChatMessage {
        let inferred = inferState(from: userText)
        let reflection = reflectionLine(for: userText, inferred: inferred)
        let body = bodyText(for: inferred, context: context)
        let handoff = handoff(for: inferred)

        let responseText = [reflection, body, "Next action: \(handoff.rawValue)."].joined(separator: "\n\n")

        return AIChatMessage(
            role: .assistant,
            text: responseText,
            inferredState: inferred,
            handoff: handoff
        )
    }

    func inferState(from text: String) -> InferredSupportState {
        let lower = text.lowercased()

        if ["panic", "heart racing", "can't calm", "can't breathe"].contains(where: lower.contains) {
            return .anxious
        }
        if ["tired", "exhausted", "drained", "spent"].contains(where: lower.contains) {
            return .exhausted
        }
        if ["sad", "low", "empty", "down"].contains(where: lower.contains) {
            return .lowMood
        }
        if ["tight", "tense", "clenched", "pain"].contains(where: lower.contains) {
            return .physicallyTense
        }
        if ["mind racing", "loop", "can't stop thinking", "wired"].contains(where: lower.contains) {
            return .activated
        }

        return .mixed
    }

    private func reflectionLine(for userText: String, inferred: InferredSupportState) -> String {
        switch inferred {
        case .activated:
            return "I hear how active your mind feels right now, especially with: “\(userText.trimmingCharacters(in: .whitespacesAndNewlines))”."
        case .exhausted:
            return "You sound deeply depleted, and it makes sense that everything feels harder tonight."
        case .anxious:
            return "It sounds like your system is in a surge, and you’re trying to regain control."
        case .lowMood:
            return "I hear the weight in what you shared. We can keep this very gentle."
        case .physicallyTense:
            return "You’re describing a body that still feels braced. Let’s work with that directly."
        case .recovering:
            return "You’re already shifting in a steadier direction."
        case .mixed:
            return "I hear that tonight feels layered, and we can simplify it to one dependable step."
        }
    }

    private func bodyText(for inferred: InferredSupportState, context: CopilotContext) -> String {
        let stateHint = context.nightState?.title ?? "your current night state"

        switch context.supportDepth {
        case .quiet:
            return "For \(stateHint): one slow exhale, unclench jaw and shoulders, then hold still for 30 seconds."
        case .steady:
            return "For \(stateHint), use this sequence: lower stimulation, do one body-settling action, and protect a 5-minute no-decision window."
        case .deep:
            let pattern = context.recentPatternSummary ?? "No prior pattern data yet"
            return "Given \(stateHint), I’d run a 3-part sequence: regulate body first, externalize one unresolved thought, then pick one low-effort anchor.\nPattern cue: \(pattern)."
        }
    }

    private func handoff(for inferred: InferredSupportState) -> AIChatMessage.HandoffAction {
        switch inferred {
        case .anxious:
            return .launchResetFlow
        case .lowMood:
            return .showGroundingPrompt
        case .activated, .physicallyTense:
            return .startTimer
        case .exhausted, .recovering, .mixed:
            return .launchResetFlow
        }
    }
}
