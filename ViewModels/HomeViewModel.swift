import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var anchorPrompt: CalmPrompt

    init() {
        self.anchorPrompt = PromptLibrary.anchorPrompt()
    }

    func refreshAnchorPrompt(date: Date = .now) {
        anchorPrompt = PromptLibrary.anchorPrompt(for: date)
    }
}
