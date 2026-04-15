import Foundation

struct PromptBuilder {
    func buildResponse(userText: String, context: CopilotContext) -> String {
        let opening = openingLine(for: context.nightState)
        let nextStep = immediateStep(for: context.nightState)
        let suggestions = suggestions(for: context.nightState, userText: userText)
            .prefix(3)
            .map { "• \($0)" }
            .joined(separator: "\n")

        return "\(opening)\n\nImmediate next step: \(nextStep)\n\n\(suggestions)"
    }

    private func openingLine(for state: NightState) -> String {
        switch state {
        case .cantSleep:
            return "You’re not behind—this moment can still become restful."
        case .wiredAfterWork:
            return "You can step down gradually from high alert."
        case .feelingOverwhelmed:
            return "We can make this simpler, one action at a time."
        case .needToReset:
            return "A short reset can create stability quickly."
        }
    }

    private func immediateStep(for state: NightState) -> String {
        switch state {
        case .cantSleep:
            return "Place the phone face down and take one long exhale right now."
        case .wiredAfterWork:
            return "Dim light and stop all stimulating input for the next minute."
        case .feelingOverwhelmed:
            return "Choose one need: water, warmth, quiet, or rest."
        case .needToReset:
            return "Sit or lie down and reduce brightness immediately."
        }
    }

    private func suggestions(for state: NightState, userText: String) -> [String] {
        var base: [String]

        switch state {
        case .cantSleep:
            base = [
                "Run the 1-minute breathing timer.",
                "Try a 5-minute quiet reset instead of clock-checking.",
                "Repeat: rest counts even before sleep."
            ]
        case .wiredAfterWork:
            base = [
                "Start a 10-minute wind-down timer.",
                "Lower room temperature slightly if comfortable.",
                "Pick one low-effort transition task like a warm drink."
            ]
        case .feelingOverwhelmed:
            base = [
                "Use the 60-second reset now.",
                "Name one thing you can postpone until tomorrow.",
                "Choose the smallest useful action and stop there."
            ]
        case .needToReset:
            base = [
                "Start the 5-minute quiet reset.",
                "Turn brightness and volume down further.",
                "Keep decisions to one next action only."
            ]
        }

        if userText.lowercased().contains("short") {
            return Array(base.prefix(2))
        }

        return base
    }
}
