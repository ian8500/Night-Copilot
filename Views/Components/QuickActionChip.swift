import SwiftUI

struct QuickActionChip: View {
    let title: String
    var subtitle: String? = nil
    var access: TierAccess = .free
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(Typography.caption.weight(.semibold))
                        .foregroundStyle(.white)

                    if access == .premium {
                        Label("Plus", systemImage: "lock.fill")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.black.opacity(0.85))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color.yellow.opacity(0.9)))
                    }
                }

                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.secondaryText)
                }
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(access == .premium ? Color.elevatedCardBackground.opacity(0.9) : Color.white.opacity(0.08))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(access == .premium ? Color.yellow.opacity(0.5) : Color.white.opacity(0.16), lineWidth: 1)
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
