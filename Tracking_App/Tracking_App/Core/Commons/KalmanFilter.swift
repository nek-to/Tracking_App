struct KalmanFilter {
    var lonState: Double = 0.0
    var lonCovariance: Double = 1.0
    var latState: Double = 0.0
    var latCovariance: Double = 1.0
    
    mutating func update(lonMeasurement: Double, latMeasurement: Double, lonMeasurementNoise: Double, latMeasurementNoise: Double, lonProcessNoise: Double, latProcessNoise: Double) -> (Double, Double) {
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
        
        return (latState, lonState)
    }
}
