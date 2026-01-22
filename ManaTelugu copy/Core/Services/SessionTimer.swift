import SwiftUI
import Combine

class SessionTimer: ObservableObject {
    @Published var isActive = false
    @Published var elapsedSeconds = 0
    
    private var timer: Timer?
    private var startTime: Date?
    
    func start() {
        guard !isActive else { return }
        
        isActive = true
        startTime = Date()
        elapsedSeconds = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedSeconds += 1
        }
    }
    
    func stop() -> Int {
        guard isActive else { return 0 }
        
        isActive = false
        timer?.invalidate()
        timer = nil
        
        let minutes = max(1, Int(ceil(Double(elapsedSeconds) / 60.0)))
        elapsedSeconds = 0
        
        return minutes
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        isActive = false
    }
    
    func resume() {
        guard !isActive else { return }
        
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedSeconds += 1
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
