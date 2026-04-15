import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    header
                    promptBlock

                    ForEach(NightState.allCases) { state in
                        NavigationLink(value: state) {
                            NightCard {
                                HStack(alignment: .center, spacing: Spacing.medium) {
                                    Image(systemName: state.systemImage)
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(Color.mutedIndigo)
                                        .frame(width: 38)

                                    Text(state.title)
                                        .font(Typography.cardTitle)
                                        .foregroundStyle(.white)

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color.white.opacity(0.45))
                                }
                                .frame(minHeight: 72)
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    AnchorCardView(prompt: viewModel.anchorPrompt)
                }
                .padding(Spacing.large)
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .navigationDestination(for: NightState.self) { state in
                GuidanceView(viewModel: GuidanceViewModel(state: state))
            }
            .onAppear {
                viewModel.refreshAnchorPrompt()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text("Night Copilot")
                .font(Typography.title)
                .foregroundStyle(.white)

            Text("Calm guidance for difficult nights")
                .font(Typography.subtitle)
                .foregroundStyle(Color.secondaryText)
        }
    }

    private var promptBlock: some View {
        NightCard {
            Text("What’s happening right now?")
                .font(Typography.cardTitle)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
