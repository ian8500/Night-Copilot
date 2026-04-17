import Foundation

struct PromptBuilder {
    func buildResponse(userText: String, context: CopilotContext) -> AIChatMessage {
        let inferred = inferState(from: userText)
        let responseText = responseText(for: inferred, userText: userText, context: context)

        return AIChatMessage(
            role: .assistant,
            text: responseText,
            inferredState: inferred,
            handoff: handoff(for: inferred)
        )
    }

    func inferState(from text: String) -> InferredSupportState {
        let lower = text.lowercased()

        if ["panic", "heart racing", "can't calm", "can't breathe", "unsafe"].contains(where: lower.contains) {
            return .anxious
        }
        if ["tired", "exhausted", "drained", "spent", "burned out"].contains(where: lower.contains) {
            return .exhausted
        }
        if ["sad", "low", "empty", "down", "numb"].contains(where: lower.contains) {
            return .lowMood
        }
        if ["tight", "tense", "clenched", "stiff", "pain"].contains(where: lower.contains) {
            return .physicallyTense
        }
        if ["mind racing", "loop", "can't stop thinking", "wired", "overthinking"].contains(where: lower.contains) {
            return .activated
        }

        return .mixed
    }

    private func responseText(for inferred: InferredSupportState, userText: String, context: CopilotContext) -> String {
        switch context.supportDepth {
        case .quiet:
            return quietResponse(for: inferred, userText: userText)
        case .steady:
            return structuredResponse(for: inferred, userText: userText, context: context, includeSuggestions: true)
        case .deep:
            return structuredResponse(for: inferred, userText: userText, context: context, includeSuggestions: true, includePatternCue: true)
        }
    }

    private func quietResponse(for inferred: InferredSupportState, userText: String) -> String {
        let reflection = reflectionLine(for: userText, inferred: inferred)
        let action = immediateAction(for: inferred)

        return [
            reflection,
            "Next step: \(action)"
        ].joined(separator: "\n\n")
    }

    private func structuredResponse(
        for inferred: InferredSupportState,
        userText: String,
        context: CopilotContext,
        includeSuggestions: Bool,
        includePatternCue: Bool = false
    ) -> String {
        var lines: [String] = []

        lines.append("A. Reflection: \(reflectionLine(for: userText, inferred: inferred))")
        lines.append("B. Insight: \(insightLine(for: inferred, stateHint: context.nightState?.title ?? "this night state"))")
        lines.append("C. Action: \(immediateAction(for: inferred))")

        if includeSuggestions {
            let suggestions = optionalSuggestions(for: inferred)
            if !suggestions.isEmpty {
                lines.append("D. Optional: \(suggestions.joined(separator: " | "))")
            }
        }

        if includePatternCue {
            let pattern = context.recentPatternSummary ?? "No strong pattern yet"
            lines.append("Pattern note: \(pattern).")
        }

        return lines.joined(separator: "\n\n")
    }

    private func reflectionLine(for userText: String, inferred: InferredSupportState) -> String {
        switch inferred {
        case .activated:
            return "It sounds like your mind is still active even though your body is tired."
        case .exhausted:
            return "You sound depleted, and that can make everything feel heavier right now."
        case .anxious:
            return "It sounds like your system is in a surge and trying to find safety again."
        case .lowMood:
            return "You seem emotionally weighed down right now, not just restless."
        case .physicallyTense:
            return "You’re carrying this in your body, especially as tension."
        case .recovering:
            return "You’re already moving toward a steadier state."
        case .mixed:
            if userText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "It sounds like tonight feels heavy and unclear."
            }
            return "You seem overloaded rather than just unable to sleep."
        }
    }

    private func insightLine(for inferred: InferredSupportState, stateHint: String) -> String {
        switch inferred {
        case .activated:
            return "This is usually a stimulation loop, so reducing input first helps faster than forcing sleep in \(stateHint.lowercased())."
        case .exhausted:
            return "When energy is low, decision load feels bigger, so one tiny action is enough tonight."
        case .anxious:
            return "Your threat system is loud, so body-based grounding is more useful than reasoning right now."
        case .lowMood:
            return "Low mood nights improve with gentleness and structure, not pressure."
        case .physicallyTense:
            return "Physical bracing can keep alertness high until muscles get a direct release signal."
        case .recovering:
            return "Small consistency protects the progress you already made."
        case .mixed:
            return "Layered nights settle faster when you shrink the next step to something simple and physical."
        }
    }

    private func immediateAction(for inferred: InferredSupportState) -> String {
        switch inferred {
        case .activated:
            return "Put your phone down, exhale slowly for 6 seconds, then do a 60-second reset timer."
        case .exhausted:
            return "Sit back, drop your shoulders, and do one minute of quiet breathing with no decisions."
        case .anxious:
            return "Place both feet on the floor, name 3 things you can see, and extend your exhale for 5 breaths."
        case .lowMood:
            return "Put one hand on your chest, one on your abdomen, and take 5 slower breaths."
        case .physicallyTense:
            return "Unclench jaw, relax hands, release shoulders, then run a 60-second body reset."
        case .recovering:
            return "Protect a calm 5-minute window with low light and no new inputs."
        case .mixed:
            return "Pick one reset tool now and follow it fully before choosing anything else."
        }
    }

    private func optionalSuggestions(for inferred: InferredSupportState) -> [String] {
        switch inferred {
        case .activated:
            return [
                "Dim screen brightness",
                "Use the shortest mode",
                "Keep tomorrow list for morning"
            ]
        case .exhausted:
            return [
                "Reduce room stimulation",
                "Sip water",
                "Set a 5-minute quiet timer"
            ]
        case .anxious:
            return [
                "Cool water on wrists",
                "Count exhales to 10",
                "Use the grounding prompt"
            ]
        case .lowMood:
            return [
                "Lower pressure for tonight",
                "Keep one light on low",
                "Use a reassuring anchor line"
            ]
        case .physicallyTense:
            return [
                "Progressively relax shoulders",
                "Soften forehead and jaw",
                "Try 1-minute breath pacing"
            ]
        case .recovering:
            return [
                "Keep pace slow",
                "Avoid decision-heavy tasks",
                "Repeat what worked earlier"
            ]
        case .mixed:
            return [
                "Choose one tool only",
                "Avoid multitasking",
                "Check in again in 3 minutes"
            ]
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
