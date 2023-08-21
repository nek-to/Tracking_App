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
        mapView.addAnnotation(placemark)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.selectAnnotation(placemark, animated: true)
        
        mapView.removeOverlays(mapView.overlays)

        var kalman = KalmanFilter()
        var filteredPoints = [CLLocationCoordinate2D]()
        points.forEach {
            let point = kalman.update(lonMeasurement: $0.longitude, latMeasurement: $0.latitude, lonMeasurementNoise: 0.005, latMeasurementNoise: 0.005, lonProcessNoise: 0.0018, latProcessNoise: 0.0018)
            filteredPoints.append(CLLocationCoordinate2D(latitude: point.0, longitude: point.1))
        }
        let tolerance = 0.00005
        let smoothLinePoint = douglasPeucker(points: points, tolerance: tolerance)
        let polyline = MKPolyline(coordinates: smoothLinePoint, count: points.count)
        
        mapView.addOverlay(polyline)
        
        let polylineBoundingRect = polyline.boundingMapRect
        mapView.setVisibleMapRect(polylineBoundingRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
    }
	
	func makeCoordinator() -> MapCoordinator {
		return MapCoordinator(parent: self)
	}
    
    func douglasPeucker(points: [CLLocationCoordinate2D], tolerance: Double) -> [CLLocationCoordinate2D] {
        // Если количество точек меньше или равно 2, возвращаем исходную полилинию
        guard points.count > 2 else {
            return points
        }
        
        let startIndex = 0
        let endIndex = points.count - 1
        
        var indicesToKeep = [startIndex, endIndex]
        
        // Рекурсивно применяем алгоритм Рамер-Дугласа-Пекера
        douglasPeuckerRecursive(points: points, startIndex: startIndex, endIndex: endIndex, tolerance: tolerance, indicesToKeep: &indicesToKeep)
        
        // Сортируем и выбираем только сохраненные индексы точек
        let simplifiedPoints = indicesToKeep.sorted().map { points[$0] }
        
        return simplifiedPoints
    }

    func douglasPeuckerRecursive(points: [CLLocationCoordinate2D], startIndex: Int, endIndex: Int, tolerance: Double, indicesToKeep: inout [Int]) {
        var maxDistance = 0.0
        var farthestIndex = startIndex
        
        // Находим точку с наибольшим расстоянием до линии
        for i in (startIndex + 1)..<endIndex {
            let distance = perpendicularDistance(point: points[i], lineStart: points[startIndex], lineEnd: points[endIndex])
            
            if distance > maxDistance {
                maxDistance = distance
                farthestIndex = i
            }
        }
        
        // Если максимальное расстояние больше заданного tolerance, добавляем точку в список сохраненных и рекурсивно применяем алгоритм к двум сегментам
        if maxDistance > tolerance {
            indicesToKeep.append(farthestIndex)
            
            douglasPeuckerRecursive(points: points, startIndex: startIndex, endIndex: farthestIndex, tolerance: tolerance, indicesToKeep: &indicesToKeep)
            douglasPeuckerRecursive(points: points, startIndex: farthestIndex, endIndex: endIndex, tolerance: tolerance, indicesToKeep: &indicesToKeep)
        }
    }

    func perpendicularDistance(point: CLLocationCoordinate2D, lineStart: CLLocationCoordinate2D, lineEnd: CLLocationCoordinate2D) -> Double {
        let x = point.latitude
        let y = point.longitude
        
        let x1 = lineStart.latitude
        let y1 = lineStart.longitude
        
        let x2 = lineEnd.latitude
        let y2 = lineEnd.longitude
        
        // Расчет перпендикулярного расстояния от точки до линии
        let numerator = abs((y2 - y1) * x - (x2 - x1) * y + x2 * y1 - y2 * x1)
        let denominator = sqrt(pow(y2 - y1, 2) + pow(x2 - x1, 2))
        
        return numerator / denominator
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
            let track = TrackingDataDecoder.shared.decodeTrackingDataFrom(TrackingFiles.first.value)
			let region = MKCoordinateRegion(center:
												CLLocationCoordinate2D(
                                                    latitude: track?.first?.points.first?.latitude ?? 0,
                                                    longitude: track?.first?.points.first?.longitude ?? 0),
											span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
			parent.mapView.setRegion(region, animated: true)
		}
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .green
                renderer.lineWidth = 4
                return renderer
            }
            
            return MKOverlayRenderer()
        }
	}
}
