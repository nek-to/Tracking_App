import Foundation

enum FileErrors: Error {
    case invalidPath
}

extension FileErrors: LocalizedError {
    var localDescription: String? {
        switch self {
        case .invalidPath:
            return "Invalid path to tha file"
        }
    }
}
