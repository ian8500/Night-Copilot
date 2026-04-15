import Foundation

@MainActor
final class ResetTimerViewModel: ObservableObject {
    @Published private(set) var remaining: TimeInterval
    @Published private(set) var isRunning = false

    let tool: ResetTool
    private var timer: Timer?
    private let haptics = TimerHapticsService()

    var progress: Double {
        let total = tool.duration
        guard total > 0 else { return 0 }
        return max(0, min(1, 1 - (remaining / total)))
    }

    init(tool: ResetTool) {
        self.tool = tool
        self.remaining = tool.duration
    }

    deinit {
        timer?.invalidate()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        haptics.notifyStart()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
    }

    func cancel() {
        pause()
        remaining = tool.duration
    }

    private func tick() {
        guard isRunning else { return }

        if remaining > 1 {
            remaining -= 1
        } else {
            remaining = 0
            isRunning = false
            timer?.invalidate()
            haptics.notifyCompletion()
        }
    }
}
