import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
	
	let mapView = MKMapView()
	let locationManager = LocationManager()
    var points: [CLLocationCoordinate2D]

	func makeUIView(context: Context) -> some UIView {
		mapView.delegate = context.coordinator
		mapView.isRotateEnabled = false
		mapView.showsUserLocation = true
		mapView.userTrackingMode = .follow
		
		return mapView
	}
    
	func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let mapView = uiView as? MKMapView else { return }
        guard let track = TrackingDataDecoder.shared.decodeTrackingDataFrom(TrackingFiles.first.value) else { return }
        let placemark = locationManager.navigateToLocation(track)
//        mapView.addAnnotation(placemark)
//
//        mapView.showAnnotations(mapView.annotations, animated: true)
//        mapView.selectAnnotation(placemark, animated: true)
        
        mapView.removeOverlays(mapView.overlays)

        var kalman = KalmanFilter()
        var filteredPoints = [CLLocationCoordinate2D]()
        points.forEach {
            let point = kalman.update(lonMeasurement: $0.longitude, latMeasurement: $0.latitude, lonMeasurementNoise: 0.01, latMeasurementNoise: 0.01, lonProcessNoise: 0.0015, latProcessNoise: 0.0015)
            filteredPoints.append(point)
        }

		if !filteredPoints.isEmpty {
			let rawPolyline = MKPolyline(coordinates: points, count: points.count)
			context.coordinator.raw = rawPolyline
			let polyline = MKPolyline(coordinates: filteredPoints, count: filteredPoints.count)
			context.coordinator.kalman = polyline
			print(points)
			print(filteredPoints)
			mapView.addOverlay(rawPolyline)
			mapView.addOverlay(polyline)

			
			let polylineBoundingRect = polyline.boundingMapRect
			mapView.setVisibleMapRect(polylineBoundingRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
		}
    }
	
	func makeCoordinator() -> MapCoordinator {
		return MapCoordinator(parent: self)
	}
}

extension MapViewRepresentable {
	class  MapCoordinator: NSObject, MKMapViewDelegate {
		let parent: MapViewRepresentable
		var raw: MKPolyline?
		var kalman: MKPolyline?
		
		init(parent: MapViewRepresentable) {
			self.parent = parent
			super.init()
		}
		
		func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
			let track = TrackingDataDecoder.shared.decodeTrackingDataFrom(TrackingFiles.first.value)
			let region = MKCoordinateRegion(center:
												CLLocationCoordinate2D(
													latitude: track?.first?.points.first?.latitude ?? 0,
													longitude: track?.first?.points.first?.longitude ?? 0),
											span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
			parent.mapView.setRegion(region, animated: true)
		}
		
		func mapView(_ mapView : MKMapView , rendererFor overlay: MKOverlay) ->MKOverlayRenderer {
			if overlay is MKPolyline {
				if ( raw  != nil) && (kalman != nil ) {
					if overlay as? MKPolyline  == raw {
						let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
						polyLineRenderer.strokeColor = .red
						polyLineRenderer.lineWidth = 3

						return polyLineRenderer
					} else if overlay as? MKPolyline  == kalman {
						print(overlay.description)
						let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
						polyLineRenderer.strokeColor = .green
						polyLineRenderer.lineWidth = 3

						return polyLineRenderer
					}
				}
			}
			return MKOverlayRenderer()
		}
	}
}
