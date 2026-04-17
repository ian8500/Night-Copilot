import Foundation

enum NightState: String, CaseIterable, Identifiable, Codable {
    case cantSwitchOff
    case mindRacing
    case bodyTense
    case feelingLow
    case wokeUpAlert
    case afterHardShift

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cantSwitchOff: return "Can’t switch off"
        case .mindRacing: return "Mind racing"
        case .bodyTense: return "Body tense"
        case .feelingLow: return "Feeling low"
        case .wokeUpAlert: return "Woke up alert"
        case .afterHardShift: return "After a hard shift"
        }
    }

    var subtitle: String {
        switch self {
        case .cantSwitchOff: return "Your system is still gripping the day"
        case .mindRacing: return "Thought loops keep reopening"
        case .bodyTense: return "Your body still feels guarded"
        case .feelingLow: return "Mood dropped and everything feels heavier"
        case .wokeUpAlert: return "You woke suddenly and now feel switched on"
        case .afterHardShift: return "You carried too much for too long"
        }
    }

    var systemImage: String {
        switch self {
        case .cantSwitchOff: return "moon.stars"
        case .mindRacing: return "brain.head.profile"
        case .bodyTense: return "figure.mind.and.body"
        case .feelingLow: return "cloud.rain"
        case .wokeUpAlert: return "eye"
        case .afterHardShift: return "briefcase"
        }
    }

    var openingLine: String {
        switch self {
        case .cantSwitchOff:
            return "You do not need to force sleep—first we help your system feel safe."
        case .mindRacing:
            return "Your mind is active, not broken. We can reduce the spin with one clear sequence."
        case .bodyTense:
            return "Your body is trying to protect you. We can signal that it can soften now."
        case .feelingLow:
            return "Low nights need gentleness and structure, not pressure."
        case .wokeUpAlert:
            return "A wake-up spike is common. We can guide your body back toward rest."
        case .afterHardShift:
            return "You carried a lot. Let’s shift out of performance mode and down-regulate."
        }
    }
}
