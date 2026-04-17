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
        case .cantSwitchOff:
            return .init(
                nightState: state,
                steps: [
                    "Lower stimulation first: dim light and pause scrolling.",
                    "Exhale longer than you inhale for one minute.",
                    "Choose one anchor: stillness, breath, or gentle audio."
                ],
                quickActions: [
                    .init(title: "Start 1-minute breathing", subtitle: "Immediate", access: .free, action: .startTool(.breathing1m)),
                    .init(title: "Grounding prompt", subtitle: "Refocus", access: .free, action: .readPrompt),
                    .init(title: "Panic-light journey", subtitle: "5-stage support", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Help me settle now",
                primaryTool: .reset60
            )
        case .mindRacing:
            return .init(
                nightState: state,
                steps: [
                    "Name the loop in one short sentence.",
                    "Move one unresolved item to tomorrow.",
                    "Return to body: jaw loose, shoulders soft, long exhale."
                ],
                quickActions: [
                    .init(title: "Start 5-minute quiet", subtitle: "Stop cognitive load", access: .free, action: .startTool(.quiet5m)),
                    .init(title: "Mind racing journey", subtitle: "4-stage support", access: .free, action: .readPrompt),
                    .init(title: "Deep guided decompression", subtitle: "Premium", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Launch mental reset",
                primaryTool: .quiet5m
            )
        case .bodyTense:
            return .init(
                nightState: state,
                steps: [
                    "Unclench hands, jaw, and stomach deliberately.",
                    "Drop temperature or use a cool cue on wrists.",
                    "Run two minutes of longer exhales."
                ],
                quickActions: [
                    .init(title: "60-second body reset", subtitle: "Fast calm", access: .free, action: .startTool(.reset60)),
                    .init(title: "Read body prompt", subtitle: "Physical cue", access: .free, action: .readPrompt),
                    .init(title: "Tension unwind script", subtitle: "Premium flow", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Start physical downshift",
                primaryTool: .breathing1m
            )
        case .feelingLow:
            return .init(
                nightState: state,
                steps: [
                    "Reduce demands: one task only for the next 10 minutes.",
                    "Choose one comfort action: warmth, hydration, or softer light.",
                    "Use Copilot Deep mode for a guided gentle check-in."
                ],
                quickActions: [
                    .init(title: "Start gentle pause", subtitle: "No pressure", access: .free, action: .startTool(.quiet5m)),
                    .init(title: "Read compassionate prompt", subtitle: "Stabilize", access: .free, action: .readPrompt),
                    .init(title: "Mood stabilization journey", subtitle: "Premium", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Begin low-pressure reset",
                primaryTool: .quiet5m
            )
        case .wokeUpAlert:
            return .init(
                nightState: state,
                steps: [
                    "Do not check the time.",
                    "Tell yourself: rest counts even before sleep.",
                    "Shift from solving to settling for five minutes."
                ],
                quickActions: [
                    .init(title: "Back-to-sleep flow", subtitle: "4 stages", access: .free, action: .readPrompt),
                    .init(title: "1-minute breathing", subtitle: "Lower alertness", access: .free, action: .startTool(.breathing1m)),
                    .init(title: "Night replay insights", subtitle: "Premium", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Return to rest mode",
                primaryTool: .breathing1m
            )
        case .afterHardShift:
            return .init(
                nightState: state,
                steps: [
                    "Say out loud that your shift is over.",
                    "Release body armor: shoulders down, hands soft.",
                    "Use a structured decompression sequence, not random steps."
                ],
                quickActions: [
                    .init(title: "10-minute wind-down", subtitle: "Structured", access: .free, action: .startTool(.windDown10m)),
                    .init(title: "Decompression prompt", subtitle: "Transition", access: .free, action: .readPrompt),
                    .init(title: "After-shift journey", subtitle: "Premium+", access: .premium, action: .openPremiumPreview)
                ],
                primaryActionTitle: "Run decompression now",
                primaryTool: .windDown10m
            )
        }
    }
}
