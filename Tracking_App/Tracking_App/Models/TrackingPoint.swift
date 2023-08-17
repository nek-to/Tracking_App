struct TrackingPoint: Codable {
	var direction: Double
	var speed: Double
	var time: String
	var longitude: Double
	var horizontalAccuracy: Double
	var latitude: Double
	var locationSpeed: Double
	var elevation: Double
	var timestamp: Double
	
	enum CodingKeys: String, CodingKey {
		case direction = "magvar"
		case speed
		case time
		case longitude = "lon"
		case horizontalAccuracy = "horizontal_accuracy"
		case latitude = "lat"
		case locationSpeed = "location_speed"
		case elevation = "ele"
		case timestamp
	}
}
