import AppKit
import Foundation

actor ClipboardWatcher {
    static let shared = ClipboardWatcher()

    private var lastChangeCount = NSPasteboard.general.changeCount
    private var lastString: String? = NSPasteboard.general.string(
        forType: .string
    )
    private var ignoreNextChange = false
    private let interval: UInt64 = 500_000_000  // 0.5s

    func skipNextChange() {
        ignoreNextChange = true
    }

    func start() {
        Task { await pollLoop() }
    }

    private func pollLoop() async {
        while true {
            try? await Task.sleep(nanoseconds: interval)

            let pasteboard = NSPasteboard.general
            
            guard pasteboard.changeCount != lastChangeCount else {return}

            if ignoreNextChange {
                ignoreNextChange = false
                continue
            }
            
            guard let current = pasteboard.string(forType: .string) else {continue}
            
            if current == lastString {
                continue
            }
            
            lastString = current
            print("[ClipboardWatcher] Captured copy \(current)")
            await StackManager.shared.push(.text(current))
        }
    }
}
