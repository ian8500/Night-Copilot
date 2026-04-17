import Foundation

struct PromptBuilder {
    func buildResponse(userText: String, context: CopilotContext) -> AIChatMessage {
        let inferred = inferState(from: userText)
        let action = pickAction(for: inferred, context: context)

        let lines = [
            "Reflection: \(reflectionLine(for: userText, inferred: inferred))",
            "Interpretation: \(interpretationLine(for: inferred))",
            "Action: \(actionLine(for: action, context: context))",
            "Next step: Tap \"\(action.rawValue)\"."
        ]

        return AIChatMessage(
            role: .assistant,
            text: lines.joined(separator: "\n\n"),
            inferredState: inferred,
            handoff: action
        )
    }

    func inferState(from text: String) -> InferredSupportState {
        let lower = text.lowercased()

        if ["mind racing", "loop", "can't stop thinking", "wired", "switched on"].contains(where: lower.contains) {
            return .mindRacing
        }
        if ["tight", "tense", "clenched", "pain", "restless body"].contains(where: lower.contains) {
            return .physicalTension
        }
        if ["overwhelmed", "too much", "breaking down", "flooded"].contains(where: lower.contains) {
            return .emotionalOverwhelm
        }
        if ["shift", "just got home", "after work", "adrenaline"].contains(where: lower.contains) {
            return .postShiftStimulation
        }
        if ["can't sleep", "another night", "again", "insomnia"].contains(where: lower.contains) {
            return .insomniaLoop
        }
        if ["panic", "heart racing", "can't calm", "can't breathe"].contains(where: lower.contains) {
            return .anxious
        }
        if ["tired", "exhausted", "drained", "spent"].contains(where: lower.contains) {
            return .exhausted
        }

        return .mixed
    }

    private func reflectionLine(for userText: String, inferred: InferredSupportState) -> String {
        switch inferred {
        case .mindRacing:
            return "It sounds like your body is tired but your mind is still running fast."
        case .physicalTension:
            return "You’re describing a body that still feels braced and guarded."
        case .emotionalOverwhelm:
            return "I hear how full and heavy this feels right now."
        case .postShiftStimulation:
            return "It sounds like you’re still carrying post-shift activation."
        case .insomniaLoop:
            return "It sounds like tonight is becoming a familiar sleep-frustration loop."
        case .anxious:
            return "I hear a high-alert surge in what you shared."
        case .exhausted:
            return "You sound depleted, like your system has little reserve left."
        case .recovering:
            return "You sound like you’re already beginning to settle."
        case .mixed:
            let compact = userText.trimmingCharacters(in: .whitespacesAndNewlines)
            return "I hear that this feels layered: \"\(compact)\"."
        }
    }

    private func interpretationLine(for inferred: InferredSupportState) -> String {
        switch inferred {
        case .mindRacing, .postShiftStimulation, .anxious:
            return "This usually reflects an activated nervous system, not a personal failure to sleep."
        case .physicalTension:
            return "This is often a body-protection state where muscles stay switched on."
        case .emotionalOverwhelm:
            return "This is likely emotional overload, so we should reduce demands before problem-solving."
        case .insomniaLoop:
            return "The pattern itself can become the trigger, so we break the loop with one predictable sequence."
        case .exhausted:
            return "Exhaustion plus activation is common; we’ll go for minimum-effort regulation first."
        case .recovering, .mixed:
            return "There’s enough signal here to take one stable next step and avoid overthinking."
        }
    }

    private func actionLine(for action: AIChatMessage.HandoffAction, context: CopilotContext) -> String {
        switch context.supportDepth {
        case .quiet:
            return quietActionLine(for: action)
        case .steady:
            return steadyActionLine(for: action)
        case .deep:
            return deepActionLine(for: action, context: context)
        }
    }

    private func quietActionLine(for action: AIChatMessage.HandoffAction) -> String {
        switch action {
        case .startTimer:
            return "Do a 2-minute settle: longer exhales, unclench jaw, eyes soft."
        case .launchResetFlow:
            return "Run a short reset to downshift stimulation."
        case .showGroundingPrompt:
            return "Read one grounding prompt slowly, twice."
        case .urgentHelp:
            return "Pause here and contact urgent support now."
        }
    }

    private func steadyActionLine(for action: AIChatMessage.HandoffAction) -> String {
        switch action {
        case .startTimer:
            return "Start a 2-minute settle, then reassess tension in shoulders, jaw, and breath pace."
        case .launchResetFlow:
            return "Use the reset flow: reduce stimulation, regulate body, then pick one low-effort anchor."
        case .showGroundingPrompt:
            return "Use a grounding prompt and pair it with one slow exhale to calm the cognitive load."
        case .urgentHelp:
            return "Stop chat and move directly to emergency support steps."
        }
    }

    private func deepActionLine(for action: AIChatMessage.HandoffAction, context: CopilotContext) -> String {
        let pattern = context.recentPatternSummary ?? "No persistent pattern detected yet"

        switch action {
        case .startTimer:
            return "Start a 2-minute settle. Then name one body sensation and one thought loop to de-fuse them. Pattern cue: \(pattern)."
        case .launchResetFlow:
            return "Run a full reset: sensory downshift, breath pacing, and one closure task. Pattern cue: \(pattern)."
        case .showGroundingPrompt:
            return "Use a grounding prompt, then write one sentence: \"Right now I only need to do this next step.\" Pattern cue: \(pattern)."
        case .urgentHelp:
            return "Pause all guidance and transition immediately to emergency support."
        }
    }

    private func pickAction(for inferred: InferredSupportState, context: CopilotContext) -> AIChatMessage.HandoffAction {
        let primary: AIChatMessage.HandoffAction
        switch inferred {
        case .emotionalOverwhelm:
            primary = .showGroundingPrompt
        case .physicalTension, .mindRacing:
            primary = .startTimer
        case .postShiftStimulation, .insomniaLoop, .exhausted, .anxious, .mixed, .recovering:
            primary = .launchResetFlow
        }

        if context.sessionMemory.wasRecentlySuggested(primary) {
            let alternatives: [AIChatMessage.HandoffAction] = [.startTimer, .showGroundingPrompt, .launchResetFlow]
            return alternatives.first(where: { $0 != primary && !context.sessionMemory.wasRecentlySuggested($0) }) ?? primary
        }

        return primary
    }
}
