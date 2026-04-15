import Foundation

enum NightState: String, CaseIterable, Identifiable {
    case cantSleep
    case wiredAfterWork
    case feelingOverwhelmed
    case needToReset

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cantSleep:
            return "Can’t sleep"
        case .wiredAfterWork:
            return "Wired after work"
        case .feelingOverwhelmed:
            return "Feeling overwhelmed"
        case .needToReset:
            return "Need to reset"
        }
    }

    var systemImage: String {
        switch self {
        case .cantSleep:
            return "moon.zzz"
        case .wiredAfterWork:
            return "bolt.horizontal.fill"
        case .feelingOverwhelmed:
            return "waveform.path.ecg"
        case .needToReset:
            return "arrow.clockwise.circle"
        }
    }

    var openingLine: String {
        switch self {
        case .cantSleep:
            return "You do not need to force sleep right now. Focus on settling first."
        case .wiredAfterWork:
            return "Your body may still be in go-mode. Let’s reduce the signals telling it to stay switched on."
        case .feelingOverwhelmed:
            return "You only need one small next step right now."
        case .needToReset:
            return "Let’s make the next few minutes simpler."
        }
    }
}
