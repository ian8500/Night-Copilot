import SwiftUI

struct GuidanceView: View {
    @StateObject var viewModel: GuidanceViewModel
    @State private var activeTool: ResetTool?
    @State private var isShowingPrompt = false
    @State private var isShowingCopilot = false
    @State private var isShowingPremiumSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                titleBlock
                stepsBlock
                quickActionsBlock
                primaryButton
            }
            .padding(Spacing.large)
            .padding(.bottom, Spacing.xLarge)
        }
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .navigationTitle(viewModel.plan.nightState.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Talk to Copilot") {
                    isShowingCopilot = true
                }
                .font(Typography.caption.weight(.semibold))
                .foregroundStyle(Color.glowAccent)
            }
        }
        .sheet(item: $activeTool) { tool in
            ResetTimerView(viewModel: ResetTimerViewModel(tool: tool))
                .presentationDetents([.fraction(0.82)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingPrompt) {
            promptSheet
                .presentationDetents([.height(300)])
        }
        .sheet(isPresented: $isShowingPremiumSheet) {
            PremiumTierSheet(
                title: "Night Copilot Plus",
                subtitle: "Deeper journeys and replay intelligence with local-first privacy."
            )
            .presentationDetents([.medium, .large])
        }
        .navigationDestination(isPresented: $isShowingCopilot) {
            AIChatView(
                viewModel: AIChatViewModel(
                    context: CopilotContext(
                        nightState: viewModel.plan.nightState,
                        currentPrompt: viewModel.selectedPrompt,
                        supportDepth: .steady
                    )
                )
            )
        }
    }

    private var titleBlock: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Immediate mode")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.textSecondary)

                Text(viewModel.plan.nightState.openingLine)
                    .font(Typography.body)
                    .foregroundStyle(Color.textPrimary)
            }
        }
    }

    private var stepsBlock: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.medium) {
                Text("Steady next steps")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.textSecondary)

                ForEach(Array(viewModel.plan.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: Spacing.small) {
                        Text("\(index + 1).")
                            .font(Typography.bodyStrong)
                            .foregroundStyle(Color.secondaryAccent)

                        Text(step)
                            .font(Typography.body)
                            .foregroundStyle(Color.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private var quickActionsBlock: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Tools")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.textSecondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.small) {
                        ForEach(viewModel.plan.quickActions) { quickAction in
                            QuickActionChip(
                                title: quickAction.title,
                                subtitle: quickAction.subtitle,
                                access: quickAction.access
                            ) {
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
            viewModel.recordToolUse(viewModel.plan.primaryTool)
            activeTool = viewModel.plan.primaryTool
        } label: {
            Text(viewModel.plan.primaryActionTitle)
                .font(Typography.actionButton)
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.primaryAccent)
                )
        }
        .buttonStyle(.plain)
        .padding(.top, Spacing.small)
    }

    private var promptSheet: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text("Grounding prompt")
                .font(Typography.cardTitle)
                .foregroundStyle(Color.textPrimary)

            Text(viewModel.selectedPrompt.text)
                .font(Typography.body)
                .foregroundStyle(Color.textSecondary)

            Button("Show another") {
                viewModel.cyclePrompt()
            }
            .font(Typography.actionButton)
            .foregroundStyle(Color.glowAccent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(Spacing.large)
        .background(LinearGradient.appBackground)
    }

    private func handleQuickAction(_ action: GuidancePlan.QuickAction.ActionType) {
        switch action {
        case .startTool(let tool):
            viewModel.recordToolUse(tool)
            activeTool = tool
        case .readPrompt:
            viewModel.recordFlowHelp(viewModel.plan.nightState.title)
            isShowingPrompt = true
        case .openPremiumPreview:
            isShowingPremiumSheet = true
        }
    }
}

#Preview {
    NavigationStack {
        GuidanceView(viewModel: GuidanceViewModel(state: .cantSwitchOff))
    }
}
