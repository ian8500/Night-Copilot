import Foundation

@MainActor
final class GuidanceViewModel: ObservableObject {
    let plan: GuidancePlan
    @Published var selectedPrompt: CalmPrompt
    private let memoryStore: NightMemoryStore?

    init(state: NightState, memoryStore: NightMemoryStore? = nil) {
        self.plan = GuidancePlan.makePlan(for: state)
        self.selectedPrompt = PromptLibrary.randomPrompt()
        self.memoryStore = memoryStore
        self.memoryStore?.recordNightState(state)
    }

    func cyclePrompt() {
        selectedPrompt = PromptLibrary.randomPrompt(excluding: selectedPrompt)
    }

    func recordToolUse(_ tool: ResetTool) {
        memoryStore?.recordToolUse(tool)
    }

    func recordFlowHelp(_ flow: String) {
        memoryStore?.recordHelpfulFlow(flow)
    }
}
