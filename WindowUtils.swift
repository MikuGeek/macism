import Cocoa
import Foundation

func createWindow(x: CGFloat, y: CGFloat, width: CGFloat,
                  height: CGFloat) -> NSWindow {
    // Create the window with borderless style to avoid taking focus
    let window = NSWindow(
        contentRect: NSRect(x: x, y: y, width: width, height: height),
        styleMask: [.borderless], 
        backing: .buffered,
        defer: false
    )

    // Set window properties for visibility
    window.isOpaque = true
    window.backgroundColor = NSColor.purple // Set background to purple
    window.level = .screenSaver // High window level for visibility
    window.collectionBehavior = [.canJoinAllSpaces, .stationary]

    // Make window visible and bring it to front without taking focus
    window.orderFront(nil)

    return window
}

// Function to show a temporary window
func showTemporaryInputWindow(waitTimeMs: Int) {
    if waitTimeMs == 0 {
        return
    }
    // Handle wait time and app termination
    let waitTime = waitTimeMs < 0 ? 1 : waitTimeMs

    let app = NSApplication.shared
    app.setActivationPolicy(.accessory)
    // Get main screen dimensions to position window in bottom-right
    guard let screen = NSScreen.main else { return }
    let screenRect = screen.visibleFrame

    // Calculate bottom-right position
    let windowWidth: CGFloat = 3
    let windowHeight: CGFloat = 3
    let xPos = screenRect.maxX - windowWidth - 8
    let yPos = screenRect.minY + 8

    let _ = createWindow(x: xPos, y: yPos, width: windowWidth,
                         height: windowHeight)

    // Do NOT call app.activate to avoid losing focus from current app
    let waitTimeSeconds = TimeInterval(waitTime) / 1000.0
    DispatchQueue.main.asyncAfter(deadline: .now() + waitTimeSeconds) {
        app.terminate(nil)
    }
    app.run()
}
