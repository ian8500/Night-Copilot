import Foundation

enum PromptLibrary {
    static let prompts: [CalmPrompt] = [
        CalmPrompt(text: "You do not need to solve the whole night at once."),
        CalmPrompt(text: "Lower the pace first, then choose one useful next action."),
        CalmPrompt(text: "Rest can begin before sleep begins."),
        CalmPrompt(text: "Small boundaries create calm quickly."),
        CalmPrompt(text: "Let this minute be enough for now."),
        CalmPrompt(text: "You are allowed to downshift without finishing everything.")
    ]

    static func anchorPrompt(for date: Date = .now) -> CalmPrompt {
        guard !prompts.isEmpty else {
            return CalmPrompt(text: "One slower breath is a complete next step.")
        }

        let day = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 0
        return prompts[day % prompts.count]
    }

    static func randomPrompt(excluding excluded: CalmPrompt? = nil) -> CalmPrompt {
        let filtered = prompts.filter { $0 != excluded }
        return filtered.randomElement() ?? prompts[0]
    }
}
