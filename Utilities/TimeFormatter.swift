import Foundation

enum TimeFormatter {
    static func mmss(from time: TimeInterval) -> String {
        let total = Int(max(0, time))
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
