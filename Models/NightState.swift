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
            return "Can’t fall asleep"
        case .wiredAfterWork:
            return "Still wired"
        case .feelingOverwhelmed:
            return "Feeling overloaded"
        case .needToReset:
            return "Need a reset"
        }
    }

    var subtitle: String {
        switch self {
        case .cantSleep:
            return "When your mind will not switch off"
        case .wiredAfterWork:
            return "When your body is still in go-mode"
        case .feelingOverwhelmed:
            return "When everything feels too loud"
        case .needToReset:
            return "When you need a clean pause"
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
            return "You do not need to force sleep. We will settle your system first."
        case .wiredAfterWork:
            return "Your body is protecting momentum. We can gently signal that the day is over."
        case .feelingOverwhelmed:
            return "You only need one steady next step right now."
        case .needToReset:
            return "Let’s simplify the next few minutes and breathe room back in."
        }
    }
}
