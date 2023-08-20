enum Algorithm: CaseIterable {
    case kalmanFilter
}

extension Algorithm {
    var name: String {
        switch self {
        case .kalmanFilter:
            return "Kalman filter"
        }
    }
}
