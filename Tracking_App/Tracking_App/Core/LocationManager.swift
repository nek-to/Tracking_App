import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
	private let locationManager = CLLocationManager()
	
	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
    
    
    func navigateToLocation(_ track: [TrackingSegment]) -> MKPlacemark {
        let coordinate = CLLocationCoordinate2D(latitude: track.first?.points.first?.latitude ?? 0,
                                                longitude: track.first?.points.first?.longitude ?? 0)
        return MKPlacemark(coordinate: coordinate)
    }
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard !locations.isEmpty else { return }
		locationManager.stopUpdatingLocation()
	}
}
