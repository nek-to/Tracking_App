import Foundation

class TrackingDataDecoder {
    static let shated = TrackingDataDecoder()
    
    private init() {}
    
    func decodeTrackingDataFrom(_ file: String) -> [TrackingSegment]? {
        if let path = Bundle.main.url(forResource: file, withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: path)
                let resultData = try JSONDecoder().decode(TrackingData.self, from: jsonData)
                return resultData.segments
            } catch {
                print(FileErrors.invalidPath.localDescription as Any)
            }
        }
        return nil
    }
}
