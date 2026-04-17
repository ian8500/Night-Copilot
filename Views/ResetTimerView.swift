import SwiftUI

struct ResetTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ResetTimerViewModel
    @State private var animateBreath = false

    var body: some View {
        VStack(spacing: Spacing.xLarge) {
            VStack(spacing: Spacing.small) {
                Text(viewModel.tool.title)
                    .font(Typography.sectionTitle)
                    .foregroundStyle(Color.textPrimary)

                Text(viewModel.tool.guidanceText)
                    .font(Typography.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.large)
            }

            ZStack {
                ProgressRingView(progress: viewModel.progress, isAnimating: viewModel.isRunning)

                VStack(spacing: Spacing.xxSmall) {
                    Text(TimeFormatter.mmss(from: viewModel.remaining))
                        .font(Typography.timer)
                        .foregroundStyle(Color.textPrimary)
                        .monospacedDigit()

                    Text(viewModel.isRunning ? "steady pace" : "ready when you are")
                        .font(Typography.caption.weight(.semibold))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .scaleEffect(animateBreath ? 1.01 : 0.99)
            .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: animateBreath)

            VStack(spacing: Spacing.small) {
                timerControl(title: viewModel.isRunning ? "Pause" : "Begin", primary: true) {
                    viewModel.isRunning ? viewModel.pause() : viewModel.start()
                }

                timerControl(title: "Reset", primary: false) {
                    viewModel.cancel()
                }
            }

            Button("Done") {
                dismiss()
            }
            .font(Typography.caption.weight(.semibold))
            .foregroundStyle(Color.textSecondary)

            Spacer(minLength: 0)
        }
        .padding(Spacing.large)
        .padding(.top, Spacing.medium)
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .onAppear {
            animateBreath = true
        }
    }

    private func timerControl(title: String, primary: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Typography.actionButton)
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(primary ? Color.primaryAccent : Color.white.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(primary ? 0 : 0.16), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ResetTimerView(viewModel: ResetTimerViewModel(tool: .quiet5m))
}
