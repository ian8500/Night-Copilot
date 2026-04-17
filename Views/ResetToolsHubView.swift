import SwiftUI

struct ResetToolsHubView: View {
    @ObservedObject var memoryStore: NightMemoryStore
    @State private var activeTool: ResetTool?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    Text("Reset tools")
                        .font(Typography.display)
                        .foregroundStyle(Color.textPrimary)

                    Text("Fast regulation tools for immediate mode.")
                        .font(Typography.body)
                        .foregroundStyle(Color.textSecondary)

                    ForEach(ResetTool.allCases) { tool in
                        Button {
                            memoryStore.recordToolUse(tool)
                            activeTool = tool
                        } label: {
                            NightCard {
                                VStack(alignment: .leading, spacing: Spacing.xSmall) {
                                    Text(tool.title)
                                        .font(Typography.cardTitle)
                                        .foregroundStyle(Color.textPrimary)
                                    Text(tool.guidanceText)
                                        .font(Typography.caption)
                                        .foregroundStyle(Color.textSecondary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Spacing.large)
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .sheet(item: $activeTool) { tool in
                ResetTimerView(viewModel: ResetTimerViewModel(tool: tool))
                    .presentationDetents([.fraction(0.82)])
            }
        }
    }
}

#Preview {
    ResetToolsHubView(memoryStore: NightMemoryStore())
}
