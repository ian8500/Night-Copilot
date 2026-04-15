import Foundation

@MainActor
final class GuidanceViewModel: ObservableObject {
    let plan: GuidancePlan
    @Published var selectedPrompt: CalmPrompt

    init(state: NightState) {
        self.plan = GuidancePlan.makePlan(for: state)
        self.selectedPrompt = PromptLibrary.randomPrompt()
    }

    func cyclePrompt() {
        selectedPrompt = PromptLibrary.randomPrompt(excluding: selectedPrompt)
    }
}
