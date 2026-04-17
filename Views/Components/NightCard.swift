import SwiftUI

struct NightCard<Content: View>: View {
    let content: Content
    var padding: CGFloat

    init(padding: CGFloat = Spacing.large, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(LinearGradient.cinematicGlow)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.cardStroke, lineWidth: 1)
                    }
                    .shadow(color: Color.black.opacity(0.45), radius: 20, y: 14)
            )
    }
}

#Preview {
    NightCard {
        Text("Preview card")
            .foregroundStyle(Color.textPrimary)
    }
    .padding()
    .background(LinearGradient.appBackground)
}
