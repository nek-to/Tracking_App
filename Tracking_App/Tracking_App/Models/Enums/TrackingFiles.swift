public enum TrackingFiles: CaseIterable {
    case first
}

extension TrackingFiles {
    var value: String {
        switch self {
        case .first:
            return "track_sample"
        }
    }
}
