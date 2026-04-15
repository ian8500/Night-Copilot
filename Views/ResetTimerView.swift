import SwiftUI

struct ResetTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ResetTimerViewModel

    var body: some View {
        VStack(spacing: Spacing.large) {
            Text(viewModel.tool.title)
                .font(Typography.cardTitle)
                .foregroundStyle(.white)

            Text(viewModel.tool.guidanceText)
                .font(Typography.body)
                .foregroundStyle(Color.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.large)

            ZStack {
                ProgressRingView(progress: viewModel.progress)
                Text(TimeFormatter.mmss(from: viewModel.remaining))
                    .font(Typography.timer)
                    .foregroundStyle(.white)
                    .monospacedDigit()
            }
            .padding(.vertical, Spacing.small)

            HStack(spacing: Spacing.small) {
                timerControl(title: viewModel.isRunning ? "Pause" : "Start", primary: true) {
                    viewModel.isRunning ? viewModel.pause() : viewModel.start()
                }

                timerControl(title: "Cancel", primary: false) {
                    viewModel.cancel()
                }
            }

            Button("Done") {
                dismiss()
            }
            .font(Typography.caption.weight(.semibold))
            .foregroundStyle(Color.secondaryText)
            .padding(.top, Spacing.xSmall)

            Spacer(minLength: 0)
        }
        .padding(Spacing.large)
        .background(LinearGradient.appBackground.ignoresSafeArea())
    }

    private func timerControl(title: String, primary: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Typography.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(primary ? Color.mutedIndigo : Color.white.opacity(0.12))
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ResetTimerView(viewModel: ResetTimerViewModel(tool: .quiet5m))
}
