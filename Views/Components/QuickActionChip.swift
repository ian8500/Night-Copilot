import SwiftUI

struct QuickActionChip: View {
    let title: String
    var subtitle: String? = nil
    var access: TierAccess = .free
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.xxxSmall) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(Typography.caption.weight(.semibold))
                        .foregroundStyle(Color.textPrimary)

                    if access == .premium {
                        Text("PREMIUM")
                            .font(Typography.micro.weight(.bold))
                            .foregroundStyle(Color.nightBackground)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color.secondaryAccent))
                    }
                }

                if let subtitle {
                    Text(subtitle)
                        .font(Typography.micro)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(access == .premium ? Color.elevatedCardBackground : Color.white.opacity(0.05))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(access == .premium ? Color.secondaryAccent.opacity(0.6) : Color.white.opacity(0.14), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        QuickActionChip(title: "Start reset", subtitle: "Core tool") {}
        QuickActionChip(title: "Deeper session", subtitle: "8-minute guide", access: .premium) {}
    }
    .padding()
    .background(LinearGradient.appBackground)
}
