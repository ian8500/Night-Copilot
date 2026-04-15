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
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.cardStroke, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.24), radius: 14, y: 8)
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
