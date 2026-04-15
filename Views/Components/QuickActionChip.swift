import SwiftUI

struct QuickActionChip: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Typography.caption.weight(.medium))
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.small)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.white.opacity(0.14), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuickActionChip(title: "Start reset") {}
        .padding()
        .background(LinearGradient.appBackground)
}
