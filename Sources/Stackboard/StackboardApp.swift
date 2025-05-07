import HotKey
import SwiftUI

@main
struct StackboardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings {
            PreferencesView()
        }
    }
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        
        if let btn = statusItem.button {
            btn.image = NSImage(
                systemSymbolName: "tray.and.arrow.down",
                accessibilityDescription: "Stackboard"
            )
            btn.action = #selector(togglePopover(_:))
            btn.target = self
        }

        Task {
            await ClipboardWatcher.shared.start()
        }

        HotKeyManager.shared.register()
    }

    @objc private func togglePopover(_ sender: Any?) {
        PopoverController.shared.toggle(sender: sender)
    }
}
