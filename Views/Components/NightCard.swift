import SwiftUI

struct NightCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(LinearGradient.heroGlow)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.cardStroke, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 16, y: 10)
            )
    }
}

#Preview {
    NightCard {
        Text("Preview card")
            .foregroundStyle(.white)
    }
    .padding()
    .background(LinearGradient.appBackground)
}
