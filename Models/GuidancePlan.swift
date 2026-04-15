import Foundation

struct GuidancePlan: Identifiable {
    let id = UUID()
    let nightState: NightState
    let steps: [String]
    let quickActions: [QuickAction]
    let primaryActionTitle: String
    let primaryTool: ResetTool

    struct QuickAction: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let access: TierAccess
        let action: ActionType

        enum ActionType {
            case startTool(ResetTool)
            case readPrompt
            case openPremiumPreview
        }
    }

    static func makePlan(for state: NightState) -> GuidancePlan {
        switch state {
        case .cantSleep:
            return GuidancePlan(
                nightState: state,
                steps: [
                    "Put the phone down for a few seconds and unclench your jaw and shoulders.",
                    "Slow your breathing for one minute without trying to control the whole night.",
                    "If sleep does not return, switch to a quiet reset rather than getting frustrated."
                ],
                quickActions: [
                    .init(title: "Start breathing timer", subtitle: "1 minute", access: .free, action: .startTool(.breathing1m)),
                    .init(title: "Read a calm prompt", subtitle: "Ground now", access: .free, action: .readPrompt),
                    .init(title: "Sleep return script", subtitle: "8-minute guided session", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Start quiet reset",
                primaryTool: .quiet5m
            )
        case .wiredAfterWork:
            return GuidancePlan(
                nightState: state,
                steps: [
                    "Lower light and stop stimulating input now.",
                    "Do one short wind-down action instead of several.",
                    "Let your system step down gradually instead of trying to crash into sleep."
                ],
                quickActions: [
                    .init(title: "Start 10-minute wind-down", subtitle: "Core tool", access: .free, action: .startTool(.windDown10m)),
                    .init(title: "Read recovery steps", subtitle: "Keep it simple", access: .free, action: .readPrompt),
                    .init(title: "After-work decompression", subtitle: "Structured unwind", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Begin wind-down",
                primaryTool: .windDown10m
            )
        case .feelingOverwhelmed:
            return GuidancePlan(
                nightState: state,
                steps: [
                    "Pause and take one slower breath than usual.",
                    "Pick one immediate need: quiet, water, warmth, or rest.",
                    "Do the smallest helpful action first."
                ],
                quickActions: [
                    .init(title: "Start 60-second reset", subtitle: "Fast relief", access: .free, action: .startTool(.reset60)),
                    .init(title: "Read grounding prompt", subtitle: "Steady your thoughts", access: .free, action: .readPrompt),
                    .init(title: "Overload recovery plan", subtitle: "5-step guide", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Start reset",
                primaryTool: .reset60
            )
        case .needToReset:
            return GuidancePlan(
                nightState: state,
                steps: [
                    "Sit or lie somewhere comfortable.",
                    "Reduce noise, brightness, and decision-making.",
                    "Follow one short reset instead of trying to fix everything."
                ],
                quickActions: [
                    .init(title: "Start 5-minute reset", subtitle: "Core tool", access: .free, action: .startTool(.quiet5m)),
                    .init(title: "Read a calming prompt", subtitle: "Reset focus", access: .free, action: .readPrompt),
                    .init(title: "Night reflection", subtitle: "Guided journal", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Start 5-minute reset",
                primaryTool: .quiet5m
            )
        }
    }
}
