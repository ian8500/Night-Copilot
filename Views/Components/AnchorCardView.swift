import SwiftUI

struct AnchorCardView: View {
    let prompt: CalmPrompt

    var body: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Tonight’s grounding line")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.secondaryText)

                Text(prompt.text)
                    .font(Typography.body)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    AnchorCardView(prompt: PromptLibrary.prompts[0])
        .padding()
        .background(LinearGradient.appBackground)
}
