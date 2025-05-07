import AppKit
import Foundation

enum Clip: Codable, Identifiable {
    case text(String)

    var id: UUID {
        switch self {
        case .text(let str):
            return UUID(uuidString: String(str.hashValue)) ?? UUID()
        }
    }

    var previewText: String {
        switch self {
        case .text(let str):
            return String(str.prefix(80)).replacingOccurrences(
                of: "\n",
                with: " "
            )
        }
    }

    var text: String? {
        if case let .text(str) = self {
            return str
        }

        return nil
    }
}
