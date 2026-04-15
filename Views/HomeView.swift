import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var isAppeared = false
    @State private var isShowingPremiumSheet = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    hero
                    valueBlock
                    stateSection
                    AnchorCardView(prompt: viewModel.anchorPrompt)
                        .opacity(isAppeared ? 1 : 0)
                        .offset(y: isAppeared ? 0 : 8)
                        .animation(.easeOut(duration: 0.45).delay(0.18), value: isAppeared)
                    tierPreviewBlock
                }
                .padding(.horizontal, Spacing.large)
                .padding(.top, Spacing.large)
                .padding(.bottom, Spacing.xxLarge)
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .navigationDestination(for: NightState.self) { state in
                GuidanceView(viewModel: GuidanceViewModel(state: state))
            }
            .sheet(isPresented: $isShowingPremiumSheet) {
                PremiumTierSheet(
                    title: "Night Copilot Plus",
                    subtitle: "A gentle premium layer for deeper support, while free tools stay strong."
                )
                .presentationDetents([.medium, .large])
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

                Text("Your calm nighttime support companion")
                    .font(Typography.sectionTitle)
                    .foregroundStyle(.white)

                Text("When sleep, stress, or emotional overload hits, Night Copilot gives immediate steps that reduce overwhelm and help you feel safe, steady, and in control.")
                    .font(Typography.body)
                    .foregroundStyle(Color.secondaryText)

                Text("Private. Non-judgmental. Built for hard nights.")
                    .font(Typography.caption.weight(.semibold))
                    .foregroundStyle(Color.tertiaryText)
                    .padding(.top, Spacing.xxSmall)
            }
        }
        .opacity(isAppeared ? 1 : 0)
        .offset(y: isAppeared ? 0 : 10)
        .animation(.easeOut(duration: 0.45), value: isAppeared)
    }

    private var valueBlock: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Why people use Night Copilot")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.secondaryText)

                valueRow(title: "Fast relief", subtitle: "Start a grounded action in under 10 seconds.")
                valueRow(title: "Gentle guidance", subtitle: "Clear steps without pressure or shame.")
                valueRow(title: "Safety-first AI", subtitle: "Escalates to crisis guidance when needed.")
            }
        }
    }

    private func valueRow(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(Typography.body.weight(.semibold))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(Typography.caption)
                .foregroundStyle(Color.secondaryText)
        }
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

    private var tierPreviewBlock: some View {
        NightCard {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Free tonight, Plus when you want more")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Color.secondaryText)

                Text("Core resets and calm chat remain free. Plus adds deeper, personalized sessions.")
                    .font(Typography.caption)
                    .foregroundStyle(.white)

                Button("Preview Night Copilot Plus") {
                    isShowingPremiumSheet = true
                }
                .font(Typography.actionButton)
                .foregroundStyle(Color.accentGlow)
                .padding(.top, 4)
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
