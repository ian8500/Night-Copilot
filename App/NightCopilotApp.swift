import SwiftUI

@main
struct NightCopilotApp: App {
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
