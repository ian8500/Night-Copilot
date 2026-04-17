import SwiftUI

struct AnchorCardView: View {
    let title: String
    let prompt: CalmPrompt
    let actionTitle: String

    var body: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(title)
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.textSecondary)

                Text(prompt.text)
                    .font(Typography.bodyStrong)
                    .foregroundStyle(Color.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(actionTitle)
                    .font(Typography.caption.weight(.semibold))
                    .foregroundStyle(Color.secondaryAccent)
                    .padding(.top, Spacing.xxxSmall)
            }
        }
    }
}

#Preview {
    AnchorCardView(
        title: "Tonight's Anchor",
        prompt: PromptLibrary.prompts[0],
        actionTitle: "Next: Start a 60-second pause"
    )
    .padding()
    .background(LinearGradient.appBackground)
}
