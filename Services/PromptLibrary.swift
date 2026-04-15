import Foundation

enum PromptLibrary {
    static let prompts: [CalmPrompt] = [
        CalmPrompt(text: "You do not need to solve the whole night at once."),
        CalmPrompt(text: "Small, quiet steps are enough right now."),
        CalmPrompt(text: "Rest can begin before sleep does."),
        CalmPrompt(text: "Tired minds need fewer choices, not more."),
        CalmPrompt(text: "Do the next kind thing, not every thing.")
    ]

    static func anchorPrompt(for date: Date = .now) -> CalmPrompt {
        guard !prompts.isEmpty else {
            return CalmPrompt(text: "Slow down. One steady breath is enough for this moment.")
        }

        let day = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 0
        return prompts[day % prompts.count]
    }

    static func randomPrompt(excluding excluded: CalmPrompt? = nil) -> CalmPrompt {
        let filtered = prompts.filter { $0 != excluded }
        return filtered.randomElement() ?? prompts[0]
    }
}
