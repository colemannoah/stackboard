import AppKit
import Foundation
import HotKey

@MainActor
class HotKeyManager {
    static let shared = HotKeyManager()

    private var pasteHotKey: HotKey?

    func register() {
        pasteHotKey = HotKey(key: .v, modifiers: [.command, .shift])
        print("[HotKeyManager] Registered CMD + SHIFT + V")

        pasteHotKey?.keyDownHandler = { [weak self] in
            print("[HotKeyManager] Hotkey triggered")

            Task {
                await self?.handlePaste()
            }
        }
    }

    private func handlePaste() async {
        print("[HotKeyManager] Paste started")

        guard let clip = await StackManager.shared.pop(),
            let text = clip.text
        else {
            print("[HotKeyManager] No clip to paste")
            return
        }

        print("[HotKeyManager] Popped clip: \(text)")

        PopoverController.shared.close()
        print("[HotKeyManager] Killing popover")

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        print("[HotKeyManager] Clipboard set to \(text)")

        try? await Task.sleep(nanoseconds: 100_000_000)

        // Synthesize a paste (CMD + V)
        let source = CGEventSource(stateID: .hidSystemState)
        let keyV: CGKeyCode = 9

        let down = CGEvent(
            keyboardEventSource: source,
            virtualKey: keyV,
            keyDown: true
        )
        down?.flags = .maskCommand

        let up = CGEvent(
            keyboardEventSource: source,
            virtualKey: keyV,
            keyDown: false
        )
        up?.flags = .maskCommand

        down?.post(tap: .cghidEventTap)
        up?.post(tap: .cghidEventTap)
        print("[HotKeyManager] Events posted to synthesize a paste")
    }
}
