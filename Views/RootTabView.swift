import SwiftUI

struct RootTabView: View {
    @StateObject private var memoryStore = NightMemoryStore()

    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel(memoryStore: memoryStore))
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            GuidedSupportHubView(memoryStore: memoryStore)
                .tabItem {
                    Label("Flows", systemImage: "square.stack.3d.up.fill")
                }

            NavigationStack {
                AIChatView(
                    viewModel: AIChatViewModel(
                        context: CopilotContext(
                            supportDepth: memoryStore.preferredDepth,
                            recentPatternSummary: memoryStore.patternSummary
                        ),
                        memoryStore: memoryStore
                    )
                )
            }
            .tabItem {
                Label("Copilot", systemImage: "message.fill")
            }

            ResetToolsHubView(memoryStore: memoryStore)
                .tabItem {
                    Label("Reset", systemImage: "timer")
                }

            NightReplayView(memoryStore: memoryStore)
                .tabItem {
                    Label("Replay", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .tint(Color.secondaryAccent)
    }
}

#Preview {
    RootTabView()
}
