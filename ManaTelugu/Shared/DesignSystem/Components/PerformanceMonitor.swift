import SwiftUI
import Foundation

// MARK: - Performance Monitoring System
class PerformanceMonitor: ObservableObject {
    @Published var frameRate: Double = 60.0
    @Published var memoryUsage: Double = 0.0
    @Published var isMonitoring = false
    
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var frameCount = 0
    private var frameTimes: [CFTimeInterval] = []
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrameRate))
        displayLink?.add(to: .main, forMode: .common)
        
        // Start memory monitoring
        startMemoryMonitoring()
    }
    
    func stopMonitoring() {
        displayLink?.invalidate()
        displayLink = nil
        isMonitoring = false
    }
    
    @objc private func updateFrameRate() {
        guard let displayLink = displayLink else { return }
        
        let currentTimestamp = displayLink.timestamp
        
        if lastTimestamp == 0 {
            lastTimestamp = currentTimestamp
            return
        }
        
        let frameTime = currentTimestamp - lastTimestamp
        frameTimes.append(frameTime)
        
        // Keep only last 60 frames for rolling average
        if frameTimes.count > 60 {
            frameTimes.removeFirst()
        }
        
        if frameTimes.count >= 10 {
            let averageFrameTime = frameTimes.reduce(0, +) / Double(frameTimes.count)
            frameRate = 1.0 / averageFrameTime
        }
        
        lastTimestamp = currentTimestamp
        frameCount += 1
    }
    
    private func startMemoryMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateMemoryUsage()
        }
    }
    
    private func updateMemoryUsage() {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            memoryUsage = Double(info.resident_size) / 1024.0 / 1024.0 // Convert to MB
        }
    }
}

// MARK: - Performance Debug View
struct PerformanceDebugView: View {
    @StateObject private var monitor = PerformanceMonitor()
    @State private var showDebug = false
    
    var body: some View {
        VStack {
            if showDebug {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Performance Monitor")
                            .font(.caption)
                            .fontWeight(.bold)
                        Spacer()
                        Button("Hide") {
                            showDebug = false
                        }
                        .font(.caption)
                    }
                    
                    HStack {
                        Text("FPS: \(String(format: "%.1f", monitor.frameRate))")
                            .font(.caption)
                            .foregroundColor(monitor.frameRate < 50 ? .red : .green)
                        
                        Spacer()
                        
                        Text("Memory: \(String(format: "%.1f", monitor.memoryUsage)) MB")
                            .font(.caption)
                            .foregroundColor(monitor.memoryUsage > 200 ? .red : .green)
                    }
                }
                .padding(8)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
            }
        }
        .onAppear {
            monitor.startMonitoring()
        }
        .onDisappear {
            monitor.stopMonitoring()
        }
        .onTapGesture(count: 3) {
            showDebug.toggle()
        }
    }
}

// MARK: - Performance-Optimized View Modifier
struct PerformanceOptimized: ViewModifier {
    let shouldOptimize: Bool
    
    func body(content: Content) -> some View {
        if shouldOptimize {
            content
                .drawingGroup() // Rasterize complex views
                .compositingGroup() // Optimize compositing
        } else {
            content
        }
    }
}

extension View {
    func performanceOptimized(_ shouldOptimize: Bool = true) -> some View {
        self.modifier(PerformanceOptimized(shouldOptimize: shouldOptimize))
    }
}

// MARK: - Lazy Loading Modifier
struct LazyLoadModifier: ViewModifier {
    @State private var isVisible = false
    let delay: TimeInterval
    
    init(delay: TimeInterval = 0.1) {
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        Group {
            if isVisible {
                content
            } else {
                // Placeholder
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 100)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isVisible = true
                }
            }
        }
    }
}

extension View {
    func lazyLoad(delay: TimeInterval = 0.1) -> some View {
        self.modifier(LazyLoadModifier(delay: delay))
    }
}

// MARK: - Memory-Efficient Image Loading
struct OptimizedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: Image?
    @State private var isLoading = false
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(image)
            } else if isLoading {
                placeholder()
            } else {
                placeholder()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        guard let url = url, !isLoading else { return }
        
        isLoading = true
        
        // Simulate async image loading
        DispatchQueue.global(qos: .userInitiated).async {
            // In a real implementation, you would load the image here
            // For now, we'll just simulate loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Placeholder image
                self.image = Image(systemName: "photo")
                self.isLoading = false
            }
        }
    }
}
