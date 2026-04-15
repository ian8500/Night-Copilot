import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.03))
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

            Circle()
                .stroke(Color.white.opacity(0.12), lineWidth: 12)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [Color.accentGlow, Color.mutedIndigo, Color.accentGlow.opacity(0.85)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color.accentGlow.opacity(0.45), radius: 8)
                .animation(.easeInOut(duration: 0.5), value: progress)

            Circle()
                .fill(Color.accentGlow.opacity(0.18))
                .padding(40)
                .scaleEffect(isAnimating ? 1.02 : 0.97)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
        }
        .frame(width: 240, height: 240)
    }
}

#Preview {
    ProgressRingView(progress: 0.42, isAnimating: true)
        .padding()
        .background(LinearGradient.appBackground)
}
