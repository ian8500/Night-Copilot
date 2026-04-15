import SwiftUI

struct ProgressRingView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.12), lineWidth: 14)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(colors: [Color.mutedIndigo, Color.white.opacity(0.85)], center: .center),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
        .frame(width: 230, height: 230)
    }
}

#Preview {
    ProgressRingView(progress: 0.42)
        .padding()
        .background(LinearGradient.appBackground)
}
