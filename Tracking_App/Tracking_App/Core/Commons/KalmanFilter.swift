import CoreLocation

struct KalmanFilter {
	var lonState: Double = 10.0
	var lonCovariance: Double = 8000.0
	var latState: Double = 10.0
	var latCovariance: Double = 8000.0
	var isFirstUpdate: Bool = true
	
	mutating func update(lonMeasurement: Double, latMeasurement: Double, lonMeasurementNoise: Double, latMeasurementNoise: Double, lonProcessNoise: Double, latProcessNoise: Double) -> CLLocationCoordinate2D {
		// Предсказание для lon
		let lonPredictedState = lonState
		let lonPredictedCovariance = lonCovariance + lonProcessNoise
		
		// Предсказание для lat
		let latPredictedState = latState
		let latPredictedCovariance = latCovariance + latProcessNoise
		
		// Обновление для lon
		let lonKalmanGain = lonPredictedCovariance / (lonPredictedCovariance + lonMeasurementNoise)
		lonState = lonPredictedState + lonKalmanGain * (lonMeasurement - lonPredictedState)
		lonCovariance = (1 - lonKalmanGain) * lonPredictedCovariance
		
		// Обновление для lat
		let latKalmanGain = latPredictedCovariance / (latPredictedCovariance + latMeasurementNoise)
		latState = latPredictedState + latKalmanGain * (latMeasurement - latPredictedState)
		latCovariance = (1 - latKalmanGain) * latPredictedCovariance
		
		// Первое обновление без ошибочных точек
//		if isFirstUpdate {
//			isFirstUpdate = false
//			return CLLocationCoordinate2D(latitude: latMeasurement, longitude: lonMeasurement)
//		}
		
		return CLLocationCoordinate2D(latitude: latState, longitude: lonState)
	}
}
