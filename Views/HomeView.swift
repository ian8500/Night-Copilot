import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var isAppeared = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    hero
                    stateSection
                    AnchorCardView(prompt: viewModel.anchorPrompt)
                        .opacity(isAppeared ? 1 : 0)
                        .offset(y: isAppeared ? 0 : 8)
                        .animation(.easeOut(duration: 0.45).delay(0.18), value: isAppeared)
                }
                .padding(.horizontal, Spacing.large)
                .padding(.top, Spacing.large)
                .padding(.bottom, Spacing.xxLarge)
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .navigationDestination(for: NightState.self) { state in
                GuidanceView(viewModel: GuidanceViewModel(state: state))
            }
            .onAppear {
                viewModel.refreshAnchorPrompt()
                isAppeared = true
            }
        }
    }

    private var hero: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.medium) {
                Text("Night Copilot")
                    .font(Typography.display)
                    .foregroundStyle(.white)

                Text("A calm space for hard nights.")
                    .font(Typography.sectionTitle)
                    .foregroundStyle(.white)

                Text("Pick what feels closest to your current moment. You’ll get clear, steady guidance right away.")
                    .font(Typography.body)
                    .foregroundStyle(Color.secondaryText)

                Text("You’re not behind. Start where you are.")
                    .font(Typography.caption.weight(.semibold))
                    .foregroundStyle(Color.tertiaryText)
                    .padding(.top, Spacing.xxSmall)
            }
        }
        .opacity(isAppeared ? 1 : 0)
        .offset(y: isAppeared ? 0 : 10)
        .animation(.easeOut(duration: 0.45), value: isAppeared)
    }

    private var stateSection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("What do you need right now?")
                .font(Typography.sectionLabel)
                .foregroundStyle(Color.secondaryText)

            ForEach(Array(NightState.allCases.enumerated()), id: \.element.id) { index, state in
                NavigationLink(value: state) {
                    NightCard {
                        HStack(alignment: .center, spacing: Spacing.medium) {
                            Image(systemName: state.systemImage)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.accentGlow)
                                .frame(width: 34)

                            VStack(alignment: .leading, spacing: Spacing.xxSmall) {
                                Text(state.title)
                                    .font(Typography.cardTitle)
                                    .foregroundStyle(.white)

                                Text(state.subtitle)
                                    .font(Typography.caption)
                                    .foregroundStyle(Color.secondaryText)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.white.opacity(0.45))
                        }
                        .frame(minHeight: 70)
                    }
                }
                .buttonStyle(.plain)
                .opacity(isAppeared ? 1 : 0)
                .offset(y: isAppeared ? 0 : 12)
                .animation(.easeOut(duration: 0.45).delay(0.08 + (Double(index) * 0.04)), value: isAppeared)
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
