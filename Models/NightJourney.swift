import Foundation

struct NightJourney: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let state: NightState
    let stages: [Stage]

    struct Stage: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let body: String
        let actionTitle: String
        let durationSeconds: Int
    }

    static let library: [NightJourney] = [
        NightJourney(
            title: "Mind Racing",
            subtitle: "Guide your thoughts from spin to sequence",
            state: .mindRacing,
            stages: [
                .init(title: "Interrupt the loop", body: "Name the loop in five words. Keep it blunt.", actionTitle: "Name one loop", durationSeconds: 45),
                .init(title: "Externalize", body: "Put one unresolved thought into a tomorrow list.", actionTitle: "Capture and defer", durationSeconds: 90),
                .init(title: "Breath ratio", body: "Inhale for 4, exhale for 6. Keep jaw loose.", actionTitle: "Start breath cadence", durationSeconds: 120),
                .init(title: "Narrow attention", body: "Notice one sound, one body contact point, one shadow.", actionTitle: "Ground in 3 points", durationSeconds: 90)
            ]
        ),
        NightJourney(
            title: "Post-Shift Decompression",
            subtitle: "Exit performance mode with structure",
            state: .afterHardShift,
            stages: [
                .init(title: "Signal closure", body: "Say: My shift is over. My body can downshift now.", actionTitle: "Close the shift", durationSeconds: 45),
                .init(title: "Body discharge", body: "Roll shoulders, unclench hands, release your tongue.", actionTitle: "Physical release", durationSeconds: 75),
                .init(title: "Hydrate + dim", body: "Take water, lower light, reduce input channels.", actionTitle: "Change your environment", durationSeconds: 120),
                .init(title: "Quiet floor", body: "Sit with no tasks for two minutes. Let adrenaline settle.", actionTitle: "Two-minute quiet", durationSeconds: 120)
            ]
        ),
        NightJourney(
            title: "Back to Sleep",
            subtitle: "For sudden wake-ups with alertness",
            state: .wokeUpAlert,
            stages: [
                .init(title: "Prevent spiral", body: "Don’t check time. Keep stimulation low.", actionTitle: "Skip the clock", durationSeconds: 30),
                .init(title: "Drop effort", body: "Tell yourself: rest counts even before sleep.", actionTitle: "Release performance", durationSeconds: 60),
                .init(title: "Body weight", body: "Feel mattress support under your shoulders and hips.", actionTitle: "Anchor physically", durationSeconds: 90),
                .init(title: "Gentle countdown", body: "Count five slower exhales, then pause.", actionTitle: "Exhale countdown", durationSeconds: 90)
            ]
        ),
        NightJourney(
            title: "Overload Reset",
            subtitle: "Create order when everything feels loud",
            state: .bodyTense,
            stages: [
                .init(title: "Reduce channels", body: "Turn one light down and mute one source of sound.", actionTitle: "Lower input", durationSeconds: 45),
                .init(title: "Single need", body: "Choose one need: water, warmth, stillness, or support.", actionTitle: "Choose one need", durationSeconds: 60),
                .init(title: "Tiny completion", body: "Do one tiny action to completion and stop.", actionTitle: "Complete one action", durationSeconds: 90),
                .init(title: "Settle sequence", body: "Sit or lie down and breathe out longer than in.", actionTitle: "Begin settle", durationSeconds: 120),
                .init(title: "Protect the boundary", body: "No new decisions for ten minutes.", actionTitle: "Hold boundary", durationSeconds: 60)
            ]
        ),
        NightJourney(
            title: "Panic-Light Settling",
            subtitle: "For elevated but manageable panic energy",
            state: .cantSwitchOff,
            stages: [
                .init(title: "Orient", body: "Look around and name where you are.", actionTitle: "Orient to room", durationSeconds: 40),
                .init(title: "Temperature cue", body: "Hold something cool or splash cool water on wrists.", actionTitle: "Apply cool cue", durationSeconds: 60),
                .init(title: "Exhale length", body: "Long exhale, short pause, repeat.", actionTitle: "Run exhale set", durationSeconds: 120),
                .init(title: "Stabilize", body: "Repeat: This surge passes. I can ride this.", actionTitle: "Repeat stabilizer", durationSeconds: 75),
                .init(title: "Choose next", body: "Pick timer, reset flow, or copilot deep mode.", actionTitle: "Select next support", durationSeconds: 45)
            ]
        )
    ]
}
