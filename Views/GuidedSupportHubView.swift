import SwiftUI

struct GuidedSupportHubView: View {
    @ObservedObject var memoryStore: NightMemoryStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    Text("Guided support flows")
                        .font(Typography.display)
                        .foregroundStyle(Color.textPrimary)

                    Text("Deeper journeys with timed stages for hard nights.")
                        .font(Typography.body)
                        .foregroundStyle(Color.textSecondary)

                    ForEach(NightJourney.library) { journey in
                        NavigationLink {
                            JourneyDetailView(journey: journey, memoryStore: memoryStore)
                        } label: {
                            NightCard {
                                VStack(alignment: .leading, spacing: Spacing.xSmall) {
                                    Text(journey.title)
                                        .font(Typography.cardTitle)
                                        .foregroundStyle(Color.textPrimary)
                                    Text(journey.subtitle)
                                        .font(Typography.caption)
                                        .foregroundStyle(Color.textSecondary)
                                    Text("\(journey.stages.count) stages")
                                        .font(Typography.micro.weight(.semibold))
                                        .foregroundStyle(Color.secondaryAccent)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Spacing.large)
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
        }
    }
}

struct JourneyDetailView: View {
    let journey: NightJourney
    @ObservedObject var memoryStore: NightMemoryStore

    @State private var stageIndex = 0
    @State private var remaining = 0
    @State private var timer: Timer?
    @State private var isRunning = false

    private var currentStage: NightJourney.Stage { journey.stages[stageIndex] }

    var body: some View {
        VStack(spacing: Spacing.large) {
            Text(journey.title)
                .font(Typography.title)
                .foregroundStyle(Color.textPrimary)

            NightCard {
                VStack(alignment: .leading, spacing: Spacing.small) {
                    Text("Stage \(stageIndex + 1) of \(journey.stages.count)")
                        .font(Typography.sectionLabel)
                        .foregroundStyle(Color.textSecondary)
                    Text(currentStage.title)
                        .font(Typography.cardTitle)
                        .foregroundStyle(Color.textPrimary)
                    Text(currentStage.body)
                        .font(Typography.body)
                        .foregroundStyle(Color.textSecondary)
                    Text("Action: \(currentStage.actionTitle)")
                        .font(Typography.caption.weight(.semibold))
                        .foregroundStyle(Color.secondaryAccent)
                }
            }

            Text("\(remaining)s")
                .font(Typography.timer)
                .foregroundStyle(Color.textPrimary)

            HStack(spacing: Spacing.small) {
                Button(isRunning ? "Pause" : "Start") {
                    isRunning ? pause() : start()
                }
                .buttonStyle(.borderedProminent)

                Button("Next Stage") {
                    nextStage()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(Spacing.large)
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .onAppear {
            remaining = currentStage.durationSeconds
            memoryStore.recordHelpfulFlow(journey.title)
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func start() {
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            Task { @MainActor in
                guard isRunning else { return }
                if remaining > 0 {
                    remaining -= 1
                } else {
                    nextStage()
                }
            }
        }
    }

    private func pause() {
        isRunning = false
        timer?.invalidate()
    }

    private func nextStage() {
        pause()
        if stageIndex < journey.stages.count - 1 {
            stageIndex += 1
            remaining = currentStage.durationSeconds
        }
    }
}

#Preview {
    GuidedSupportHubView(memoryStore: NightMemoryStore())
}
