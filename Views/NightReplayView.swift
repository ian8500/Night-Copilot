import SwiftUI

struct NightReplayView: View {
    @ObservedObject var memoryStore: NightMemoryStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    Text("Night Replay")
                        .font(Typography.display)
                        .foregroundStyle(Color.textPrimary)

                    Text("Private, local patterns from your recent nights.")
                        .font(Typography.body)
                        .foregroundStyle(Color.textSecondary)

                    NightCard {
                        VStack(alignment: .leading, spacing: Spacing.xSmall) {
                            Text("Preferred support depth")
                                .font(Typography.sectionLabel)
                                .foregroundStyle(Color.textSecondary)
                            Text(memoryStore.preferredDepth.title)
                                .font(Typography.cardTitle)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }

                    NightCard {
                        VStack(alignment: .leading, spacing: Spacing.xSmall) {
                            Text("Most used reset tool")
                                .font(Typography.sectionLabel)
                                .foregroundStyle(Color.textSecondary)
                            Text(memoryStore.mostUsedTool?.title ?? "No tool usage recorded yet")
                                .font(Typography.cardTitle)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }

                    NightCard {
                        VStack(alignment: .leading, spacing: Spacing.xSmall) {
                            Text("Recent pattern")
                                .font(Typography.sectionLabel)
                                .foregroundStyle(Color.textSecondary)
                            Text(memoryStore.patternSummary)
                                .font(Typography.body)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }

                    NightCard {
                        VStack(alignment: .leading, spacing: Spacing.xSmall) {
                            Text("Premium preview")
                                .font(Typography.sectionLabel)
                                .foregroundStyle(Color.textSecondary)
                            Text("Timeline replay, trigger windows, and adaptive flow recommendations.")
                                .font(Typography.body)
                                .foregroundStyle(Color.textPrimary)
                            Text("Tasteful preview only — core help stays fully available.")
                                .font(Typography.caption)
                                .foregroundStyle(Color.secondaryAccent)
                        }
                    }
                }
                .padding(Spacing.large)
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
        }
    }
}

#Preview {
    NightReplayView(memoryStore: NightMemoryStore())
}
