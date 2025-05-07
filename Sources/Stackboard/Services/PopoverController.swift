import AppKit
import SwiftUI

@MainActor
final class PopoverController {
    static let shared = PopoverController()

    private let popover: NSPopover

    private init() {
        popover = NSPopover()
        popover.contentSize = .init(width: 300, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: ClipListView()
        )
    }

    func toggle(sender: Any?) {
        guard let button = sender as? NSStatusBarButton else { return }

        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(
                relativeTo: button.bounds,
                of: button,
                preferredEdge: .minY
            )

            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    func close() {
        popover.performClose(nil)
    }
}
