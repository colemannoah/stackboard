import SwiftUI

struct PreferencesView: View {
    @AppStorage("maxClips") private var maxClips = 50
    @AppStorage("pollInterval") private var pollInterval = 500

    var body: some View {
        Form {
            Section("General") {
                Stepper(
                    "Max clips: \(maxClips)",
                    value: $maxClips,
                    in: 10...200
                )
                Stepper(
                    "Poll interval: \(pollInterval) ms",
                    value: $pollInterval,
                    in: 100...2000,
                    step: 100
                )
            }
        }
        .padding()
        .frame(width: 300)
    }
}
