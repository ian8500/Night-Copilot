import SwiftUI

struct GuidanceView: View {
    @StateObject var viewModel: GuidanceViewModel
    @State private var activeTool: ResetTool?
    @State private var isShowingPrompt = false
    @State private var isShowingCopilot = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                titleBlock
                stepsBlock
                quickActionsBlock
                primaryButton
            }
            .padding(Spacing.large)
        }
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .navigationTitle(viewModel.plan.nightState.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Ask Copilot") {
                    isShowingCopilot = true
                }
                .font(Typography.caption.weight(.semibold))
                .foregroundStyle(Color.mutedIndigo)
            }
        }
        .sheet(item: $activeTool) { tool in
            ResetTimerView(viewModel: ResetTimerViewModel(tool: tool))
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingPrompt) {
            promptSheet
                .presentationDetents([.height(280)])
        }
        .navigationDestination(isPresented: $isShowingCopilot) {
            AIChatView(
                viewModel: AIChatViewModel(
                    context: CopilotContext(
                        nightState: viewModel.plan.nightState,
                        currentPrompt: viewModel.selectedPrompt
                    )
                )
            )
        }
    }

    private var titleBlock: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(viewModel.plan.nightState.title)
                    .font(Typography.title)
                    .foregroundStyle(.white)

                Text(viewModel.plan.nightState.openingLine)
                    .font(Typography.body)
                    .foregroundStyle(Color.secondaryText)
            }
        }
    }

    private var stepsBlock: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.medium) {
                ForEach(Array(viewModel.plan.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: Spacing.small) {
                        Text("\(index + 1).")
                            .font(Typography.body.weight(.semibold))
                            .foregroundStyle(Color.mutedIndigo)

                        Text(step)
                            .font(Typography.body)
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private var quickActionsBlock: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Quick actions")
                    .font(Typography.caption.weight(.semibold))
                    .foregroundStyle(Color.secondaryText)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.small) {
                        ForEach(viewModel.plan.quickActions) { quickAction in
                            QuickActionChip(title: quickAction.title) {
                                handleQuickAction(quickAction.action)
                            }
                        }
                    }
                }
            }
        }
    }

    private var primaryButton: some View {
        Button {
            activeTool = viewModel.plan.primaryTool
        } label: {
            Text(viewModel.plan.primaryActionTitle)
                .font(Typography.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.mutedIndigo)
                )
        }
        .buttonStyle(.plain)
        .padding(.top, Spacing.small)
    }

    private var promptSheet: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text("Calming prompt")
                .font(Typography.cardTitle)
                .foregroundStyle(.white)

            Text(viewModel.selectedPrompt.text)
                .font(Typography.body)
                .foregroundStyle(Color.secondaryText)

            Button("Show another") {
                viewModel.cyclePrompt()
            }
            .font(Typography.body.weight(.semibold))
            .foregroundStyle(Color.mutedIndigo)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(Spacing.large)
        .background(LinearGradient.appBackground)
    }

    private func handleQuickAction(_ action: GuidancePlan.QuickAction.ActionType) {
        switch action {
        case .startTool(let tool):
            activeTool = tool
        case .readPrompt:
            isShowingPrompt = true
        }
    }
}

#Preview {
    NavigationStack {
        GuidanceView(viewModel: GuidanceViewModel(state: .cantSleep))
    }
}
