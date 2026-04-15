import SwiftUI

struct PremiumTierSheet: View {
    let title: String
    let subtitle: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.large) {
                Text(title)
                    .font(Typography.cardTitle)
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(Typography.body)
                    .foregroundStyle(Color.secondaryText)

                tierBlock(title: "Included in Free", features: TierCatalog.freeFeatures)
                tierBlock(title: "Night Copilot Plus (Preview)", features: TierCatalog.premiumFeatures)

                Text("No pressure: your current tools remain fully usable without upgrading.")
                    .font(Typography.caption.weight(.semibold))
                    .foregroundStyle(Color.tertiaryText)
            }
            .padding(Spacing.large)
        }
        .background(LinearGradient.appBackground.ignoresSafeArea())
    }

    private func tierBlock(title: String, features: [TierFeature]) -> some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(title)
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.secondaryText)

                ForEach(features) { feature in
                    HStack(alignment: .top, spacing: Spacing.small) {
                        Image(systemName: feature.tier == .free ? "checkmark.circle.fill" : "sparkles")
                            .foregroundStyle(feature.tier == .free ? Color.accentGlow : Color.yellow.opacity(0.85))
                            .padding(.top, 2)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(feature.title)
                                .font(Typography.body.weight(.semibold))
                                .foregroundStyle(.white)

                            Text(feature.detail)
                                .font(Typography.caption)
                                .foregroundStyle(Color.secondaryText)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PremiumTierSheet(
        title: "Night Copilot Plus",
        subtitle: "A lightweight premium layer for people who want deeper support."
    )
}
