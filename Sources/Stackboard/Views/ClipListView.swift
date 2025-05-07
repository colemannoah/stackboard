import AppKit
import SwiftUI

struct ClipListView: View {
    @State private var clips: [Clip] = []

    var body: some View {
        VStack(alignment: .leading) {
            Text("Stackboard")
                .font(.title)
                .padding(.top)
                .padding(.leading)

            if clips.isEmpty {
                Spacer()
                Text("No clips yet.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                List(clips) { clip in
                    Text(clip.previewText)
                        .lineLimit(1)
                        .onTapGesture {
                            Task {
                                print("[ClipListView] Tapped on \(clip.previewText)")
                                await paste(clip)
                                await refreshClips()
                                print("[ClipListView] After pasting, reloaded \(clips.count) clips")
                            }
                        }
                }
            }
        }
        .frame(width: 300, height: 400)
        .onAppear {
            Task {
                print("[ClipListView] onApper hit, loading clips")
                await loadClips()
                print("[ClipListView] Loaded \(clips.count) clips")
            }
        }
    }

    private func loadClips() async {
        clips = await StackManager.shared.allClips()
    }

    private func refreshClips() async {
        clips = await StackManager.shared.allClips()
    }

    private func paste(_ clip: Clip) async {
        _ = await StackManager.shared.pop()

        if let text = clip.text {
            let pb = NSPasteboard.general
            pb.clearContents()
            pb.setString(text, forType: .string)
        }
    }
}
