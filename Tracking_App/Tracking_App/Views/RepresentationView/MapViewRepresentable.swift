import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
	let mapView = MKMapView()
	let locationManager = LocationManager()

	func makeUIView(context: Context) -> some UIView {
		mapView.delegate = context.coordinator
		mapView.isRotateEnabled = false
		mapView.showsUserLocation = true
		mapView.userTrackingMode = .follow
		
		return mapView
	}
	
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let mapView = uiView as? MKMapView else { return }
        guard let track = TrackingDataDecoder.shated.decodeTrackingDataFrom(TrackingFiles.first.value) else { return }
        let placemark = locationManager.navigateToLocation(track)
        mapView.addAnnotation(placemark)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.selectAnnotation(placemark, animated: true)
    }
	
	func makeCoordinator() -> MapCoordinator {
		return MapCoordinator(parent: self)
	}
}

extension MapViewRepresentable {
	class  MapCoordinator: NSObject, MKMapViewDelegate {
		let parent: MapViewRepresentable
		
		init(parent: MapViewRepresentable) {
			self.parent = parent
			super.init()
		}
        
		func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
			let region = MKCoordinateRegion(center:
												CLLocationCoordinate2D(
													latitude: userLocation.coordinate.latitude,
													longitude: userLocation.coordinate.longitude),
											span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
			parent.mapView.setRegion(region, animated: true)
		}
	}
}
