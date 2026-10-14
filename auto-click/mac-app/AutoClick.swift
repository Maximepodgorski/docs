import SwiftUI
import ApplicationServices

final class Clicker: ObservableObject {
    @Published var running = false
    @Published var interval: Double = 60
    @Published var clicks = true
    @Published var status = "Arrêté"

    private var timer: Timer?

    func toggle() {
        running ? stop() : start()
    }

    private func start() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        guard AXIsProcessTrustedWithOptions(options) else {
            status = "Autorise AutoClick dans Réglages Système → Confidentialité et sécurité → Accessibilité, puis relance l'app."
            return
        }
        running = true
        tick()
        timer = Timer.scheduledTimer(withTimeInterval: max(interval, 1), repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
        running = false
        status = "Arrêté"
    }

    private func tick() {
        guard let current = CGEvent(source: nil)?.location else { return }
        let screen = CGDisplayBounds(CGMainDisplayID())
        let p = CGPoint(
            x: min(max(current.x + .random(in: -40...40), screen.minX + 5), screen.maxX - 5),
            y: min(max(current.y + .random(in: -40...40), screen.minY + 5), screen.maxY - 5)
        )
        CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: p, mouseButton: .left)?
            .post(tap: .cghidEventTap)
        if clicks {
            CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: p, mouseButton: .left)?
                .post(tap: .cghidEventTap)
            CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: p, mouseButton: .left)?
                .post(tap: .cghidEventTap)
        }
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        status = "Dernière action à \(f.string(from: Date()))" + (clicks ? " (déplacement + clic)" : " (déplacement)")
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

@main
struct AutoClickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var clicker = Clicker()

    var body: some Scene {
        WindowGroup {
            VStack(spacing: 14) {
                Text("AutoClick").font(.title2.bold())

                HStack {
                    Text("Toutes les")
                    TextField("", value: $clicker.interval, format: .number)
                        .frame(width: 50)
                        .multilineTextAlignment(.trailing)
                    Text("secondes")
                }
                .disabled(clicker.running)

                Toggle("Cliquer (sinon, déplace seulement la souris)", isOn: $clicker.clicks)

                Button(clicker.running ? "Arrêter" : "Démarrer") { clicker.toggle() }
                    .keyboardShortcut(.defaultAction)
                    .controlSize(.large)

                Text(clicker.status)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(width: 340)
        }
        .windowResizability(.contentSize)
    }
}
