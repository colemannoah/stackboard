import HotKey
import SwiftUI

@main
struct StackboardApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var applicationDelegate

  var body: some Scene {
    Settings {
      Text("Stackboard is running!")
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem!

  func applicationDidFinishLaunching(_ notification: Notification) {
    // Create the status item
    // 1. Set up menu-bar icon
    statusItem = NSStatusBar.system.statusItem(withLength: .variable)
    statusItem.button?.image = NSImage(
      systemSymbolName: "tray.and.arrow.down", accessibilityDescription: "Stackboard")
  }
}
