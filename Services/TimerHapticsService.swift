import Foundation

#if canImport(UIKit)
import UIKit
#endif

struct TimerHapticsService {
    func notifyStart() {
        #if canImport(UIKit)
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        #endif
    }

    func notifyCompletion() {
        #if canImport(UIKit)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }
}
