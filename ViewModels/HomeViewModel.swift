import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var anchorPrompt: CalmPrompt
    @Published var selectedState: NightState = .cantSwitchOff
    @Published var memoryStore: NightMemoryStore

    init(memoryStore: NightMemoryStore = NightMemoryStore()) {
        self.memoryStore = memoryStore
        self.anchorPrompt = PromptLibrary.anchorPrompt()
    }

    func refreshAnchorPrompt(date: Date = .now) {
        anchorPrompt = PromptLibrary.anchorPrompt(for: date)
    }

    func setState(_ state: NightState) {
        selectedState = state
        memoryStore.recordNightState(state)
    }

    var tonightAnchorAction: String {
        if let tool = memoryStore.mostUsedTool {
            return "Next: Start \(tool.title)"
        }
        return "Next: Start 60-second pause"
    }

    var recentHelpfulToolText: String {
        memoryStore.mostUsedTool?.title ?? "No recent tool yet"
    }

    var recentHelpfulFlowText: String {
        memoryStore.recentHelpfulFlow ?? "Try a guided support journey tonight"
    }
}
