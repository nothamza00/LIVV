import Foundation
import CoreMotion

class StepSensorManager: ObservableObject {
    static let shared = StepSensorManager()
    private let pedometer = CMPedometer()
    
    @Published var steps: Int = 0
    @Published var distanceKm: Double = 0.0
    @Published var isSensorAvailable: Bool = CMPedometer.isStepCountingAvailable()
    
    func startTracking() {
        guard isSensorAvailable else { return }
        let startOfDay = Calendar.current.startOfDay(for: Date())
        
        pedometer.startUpdates(from: startOfDay) { [weak self] data, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.steps = data.numberOfSteps.intValue
                if let distance = data.distance?.doubleValue {
                    self?.distanceKm = distance / 1000.0
                }
            }
        }
    }
}