import Foundation

actor StackManager {
    static let shared = StackManager()
    private let maxClips = 50
    private var stack: [Clip] = []

    private static var historyURL: URL {
        let fm = FileManager.default
        let dir =
            fm
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Stackboard", isDirectory: true)

        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)

        return dir.appendingPathComponent("history.json")
    }

    private init() {
        do {
            let data = try Data(contentsOf: Self.historyURL)
            let saved = try JSONDecoder().decode([Clip].self, from: data)

            self.stack = saved
        } catch {
            self.stack = []
        }
    }

    func push(_ clip: Clip) async {
        stack.insert(clip, at: 0)
        print("[StackManager] Pushed clip: \(clip.previewText)")
        print("[StackManager] Stack size is now: \(stack.count)")

        if stack.count > maxClips {
            stack.removeLast()
            print(
                "[StackManager] Trimmed oldest clip, size is now: \(stack.count)"
            )
        }

        save()
    }

    func pop() async -> Clip? {
        defer { save() }
        
        guard !stack.isEmpty else {
            print("[StackManager] Pop was requested but the stack is empty...")
            return nil
        }
        
        let popped = stack.removeFirst()
        print("[StackManager] Popped clip: \(popped.previewText); size is now \(stack.count)")
        
        return popped
    }

    func allClips() async -> [Clip] {
        stack
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(stack)
            try data.write(to: Self.historyURL, options: [.atomic])
        } catch {
            print("StackManager.save() failed:", error)
        }
    }
}
