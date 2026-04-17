import Foundation

@MainActor
final class NightMemoryStore: ObservableObject {
    @Published private(set) var preferredDepth: SupportDepthMode
    @Published private(set) var mostUsedTool: ResetTool?
    @Published private(set) var recentHelpfulFlow: String?
    @Published private(set) var statePatternCounts: [NightState: Int]

    private let defaults: UserDefaults

    private enum Key {
        static let preferredDepth = "night.memory.preferredDepth"
        static let mostUsedTool = "night.memory.mostUsedTool"
        static let recentHelpfulFlow = "night.memory.recentHelpfulFlow"
        static let statePatternCounts = "night.memory.statePatternCounts"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.preferredDepth = SupportDepthMode(rawValue: defaults.string(forKey: Key.preferredDepth) ?? "") ?? .steady
        self.mostUsedTool = ResetTool(rawValue: defaults.string(forKey: Key.mostUsedTool) ?? "")
        self.recentHelpfulFlow = defaults.string(forKey: Key.recentHelpfulFlow)

        if let data = defaults.data(forKey: Key.statePatternCounts),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            var reconstructed: [NightState: Int] = [:]
            NightState.allCases.forEach { state in
                reconstructed[state] = decoded[state.rawValue] ?? 0
            }
            self.statePatternCounts = reconstructed
        } else {
            self.statePatternCounts = Dictionary(uniqueKeysWithValues: NightState.allCases.map { ($0, 0) })
        }
    }

    func setPreferredDepth(_ depth: SupportDepthMode) {
        preferredDepth = depth
        defaults.set(depth.rawValue, forKey: Key.preferredDepth)
    }

    func recordToolUse(_ tool: ResetTool) {
        mostUsedTool = tool
        defaults.set(tool.rawValue, forKey: Key.mostUsedTool)
    }

    func recordHelpfulFlow(_ flow: String) {
        recentHelpfulFlow = flow
        defaults.set(flow, forKey: Key.recentHelpfulFlow)
    }

    func recordNightState(_ state: NightState) {
        statePatternCounts[state, default: 0] += 1
        persistCounts()
    }

    var patternSummary: String {
        let top = statePatternCounts.max(by: { $0.value < $1.value })
        guard let top, top.value > 0 else {
            return "Not enough pattern history yet"
        }
        return "Most frequent recent state: \(top.key.title)"
    }

    private func persistCounts() {
        let encoded = Dictionary(uniqueKeysWithValues: statePatternCounts.map { ($0.key.rawValue, $0.value) })
        if let data = try? JSONEncoder().encode(encoded) {
            defaults.set(data, forKey: Key.statePatternCounts)
        }
    }
}
