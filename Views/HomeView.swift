import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var openSelectedState = false
    @State private var openCopilot = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    hero
                    openingLine
                    heroActions
                    nightMap
                    anchor
                    recentTools
                }
                .padding(.horizontal, Spacing.large)
                .padding(.top, Spacing.large)
                .padding(.bottom, Spacing.xxxLarge)
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .navigationDestination(isPresented: $openSelectedState) {
                GuidanceView(viewModel: GuidanceViewModel(state: viewModel.selectedState, memoryStore: viewModel.memoryStore))
            }
            .navigationDestination(isPresented: $openCopilot) {
                AIChatView(
                    viewModel: AIChatViewModel(
                        context: CopilotContext(
                            nightState: viewModel.selectedState,
                            currentPrompt: viewModel.anchorPrompt,
                            supportDepth: viewModel.memoryStore.preferredDepth,
                            recentPatternSummary: viewModel.memoryStore.patternSummary
                        ),
                        memoryStore: viewModel.memoryStore
                    )
                )
            }
            .onAppear {
                viewModel.refreshAnchorPrompt()
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text("Night Copilot")
                .font(Typography.hero)
                .foregroundStyle(Color.textPrimary)

            Text("Layered support for nights that go off-track")
                .font(Typography.heroSubtitle)
                .foregroundStyle(Color.textSecondary)
        }
    }

    private var openingLine: some View {
        Text("You’re not behind. We can make this night easier in one steady step.")
            .font(Typography.bodyStrong)
            .foregroundStyle(Color.secondaryAccent)
            .padding(.bottom, Spacing.xxSmall)
    }

    private var heroActions: some View {
        HStack(spacing: Spacing.small) {
            actionButton(title: "Help me settle now", subtitle: "Immediate mode", icon: "bolt.fill") {
                openSelectedState = true
            }
            actionButton(title: "Talk to Copilot", subtitle: "Adaptive support", icon: "message.fill") {
                openCopilot = true
            }
        }
    }

    private func actionButton(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                Text(title)
                    .font(Typography.bodyStrong)
                Text(subtitle)
                    .font(Typography.caption)
                    .foregroundStyle(Color.textSecondary)
            }
            .foregroundStyle(Color.textPrimary)
            .padding(Spacing.medium)
            .frame(maxWidth: .infinity, minHeight: 118, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.elevatedCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.glowAccent.opacity(0.4), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var nightMap: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Night Map")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.textSecondary)

                Text("Choose what is most true right now")
                    .font(Typography.body)
                    .foregroundStyle(Color.textPrimary)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.xSmall) {
                    ForEach(NightState.allCases) { state in
                        Button {
                            viewModel.setState(state)
                        } label: {
                            HStack {
                                Text(state.title)
                                    .font(Typography.caption.weight(.semibold))
                                    .lineLimit(1)
                                Spacer()
                            }
                            .padding(.horizontal, Spacing.small)
                            .padding(.vertical, 10)
                            .foregroundStyle(viewModel.selectedState == state ? Color.nightBackground : Color.textPrimary)
                            .background(
                                Capsule()
                                    .fill(viewModel.selectedState == state ? Color.secondaryAccent : Color.white.opacity(0.06))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var anchor: some View {
        AnchorCardView(
            title: "Tonight’s Anchor",
            prompt: viewModel.anchorPrompt,
            actionTitle: viewModel.tonightAnchorAction
        )
    }

    private var recentTools: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                Text("Recently helpful")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.textSecondary)

                Text("Tool: \(viewModel.recentHelpfulToolText)")
                    .font(Typography.bodyStrong)
                    .foregroundStyle(Color.textPrimary)

                Text("Flow: \(viewModel.recentHelpfulFlowText)")
                    .font(Typography.caption)
                    .foregroundStyle(Color.textSecondary)
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
