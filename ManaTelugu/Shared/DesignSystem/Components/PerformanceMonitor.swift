import SwiftUI
import Foundation

// MARK: - Performance Monitoring System

// PerformanceMonitor tracks and publishes app frame rate (FPS) and memory usage in real time.
// Use for debugging and performance optimization during development.
class PerformanceMonitor: ObservableObject {
    // The app's current frame rate, updated every frame (default 60 FPS target).
    @Published var frameRate: Double = 60.0
    // Current app memory usage in megabytes (MB).
    @Published var memoryUsage: Double = 0.0
    // Indicates if monitoring is active.
    @Published var isMonitoring = false
    
    // CADisplayLink is used for tracking frame rates.
    private var displayLink: CADisplayLink?
    // Last CADisplayLink timestamp for measuring intervals between frames.
    private var lastTimestamp: CFTimeInterval = 0
    // Counts frames since monitoring started.
    private var frameCount = 0
    // Stores recent frame times for rolling average FPS calculation.
    private var frameTimes: [CFTimeInterval] = []
    
    // Starts frame rate and memory monitoring if not already running.
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        // CADisplayLink calls updateFrameRate() on every frame.
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrameRate))
        displayLink?.add(to: .main, forMode: .common)
        
        // Start periodic memory monitoring.
        startMemoryMonitoring()
    }
    
    // Stops frame rate and memory monitoring.
    func stopMonitoring() {
        displayLink?.invalidate()
        displayLink = nil
        isMonitoring = false
    }
    
    // Called every display frame. Updates frame rate using rolling average.
    @objc private func updateFrameRate() {
        guard let displayLink = displayLink else { return }
        
        let currentTimestamp = displayLink.timestamp
        
        if lastTimestamp == 0 {
            lastTimestamp = currentTimestamp
            return
        }
        
        // Calculate time since last frame and store for FPS calculation.
        let frameTime = currentTimestamp - lastTimestamp
        frameTimes.append(frameTime)
        
        // Keep only the last 60 frame times for averaging.
        if frameTimes.count > 60 {
            frameTimes.removeFirst()
        }
        
        // Once at least 10 frames are collected, compute FPS as inverse of average frame time.
        if frameTimes.count >= 10 {
            let averageFrameTime = frameTimes.reduce(0, +) / Double(frameTimes.count)
            frameRate = 1.0 / averageFrameTime
        }
        
        lastTimestamp = currentTimestamp
        frameCount += 1
    }
    
    // Starts a repeating timer to periodically update memory usage.
    private func startMemoryMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateMemoryUsage()
        }
    }
    
    // Gets current app memory usage using mach APIs and updates published value.
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
        
        // Convert resident size (bytes) to MB if call successful.
        if kerr == KERN_SUCCESS {
            memoryUsage = Double(info.resident_size) / 1024.0 / 1024.0 // Convert to MB
        }
    }
}

// MARK: - Performance Debug View

// PerformanceDebugView overlays a small UI showing live FPS and memory usage for debugging.
// Triple-tap to show or hide the performance HUD.
struct PerformanceDebugView: View {
    // Shared performance monitor instance.
    @StateObject private var monitor = PerformanceMonitor()
    // Controls visibility of the debug overlay.
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
                            // Hide the debug overlay.
                            showDebug = false
                        }
                        .font(.caption)
                    }
                    
                    HStack {
                        // Display FPS, coloring red if low, green if healthy.
                        Text("FPS: \(String(format: "%.1f", monitor.frameRate))")
                            .font(.caption)
                            .foregroundColor(monitor.frameRate < 50 ? .red : .green)
                        
                        Spacer()
                        // Show memory usage, warn in red if over 200MB.
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
            // Start performance monitoring when view appears.
            monitor.startMonitoring()
        }
        .onDisappear {
            // Stop monitoring when view disappears.
            monitor.stopMonitoring()
        }
        .onTapGesture(count: 3) {
            // Triple tap toggles visibility of the debug overlay.
            showDebug.toggle()
        }
    }
}

// MARK: - Performance-Optimized View Modifier

// PerformanceOptimized is a SwiftUI ViewModifier for rasterizing and compositing complex views for better performance.
struct PerformanceOptimized: ViewModifier {
    // If true, apply performance optimizations.
    let shouldOptimize: Bool
    
    func body(content: Content) -> some View {
        if shouldOptimize {
            // Rasterize and optimize compositing.
            content
                .drawingGroup()
                .compositingGroup()
        } else {
            content
        }
    }
}

// Extension so performanceOptimized can be called on any View.
extension View {
    func performanceOptimized(_ shouldOptimize: Bool = true) -> some View {
        self.modifier(PerformanceOptimized(shouldOptimize: shouldOptimize))
    }
}

// MARK: - Lazy Loading Modifier

// LazyLoadModifier delays the loading of a view until after a short time, for smoother scrolling or memory savings.
struct LazyLoadModifier: ViewModifier {
    // Indicates if the actual content should be shown.
    @State private var isVisible = false
    // How long to delay before showing the real content.
    let delay: TimeInterval
    
    init(delay: TimeInterval = 0.1) {
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        Group {
            if isVisible {
                // Show the actual content.
                content
            } else {
                // Placeholder (empty) while waiting.
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 100)
            }
        }
        .onAppear {
            // After delay, animate in the content.
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isVisible = true
                }
            }
        }
    }
}

// Extension so lazyLoad can be called on any View.
extension View {
    func lazyLoad(delay: TimeInterval = 0.1) -> some View {
        self.modifier(LazyLoadModifier(delay: delay))
    }
}

// MARK: - Memory-Efficient Image Loading

// OptimizedAsyncImage is a lightweight async image loader for SwiftUI.
// It simulates async loading, supports placeholder, and is extensible for real network/image cache implementations.
struct OptimizedAsyncImage<Content: View, Placeholder: View>: View {
    // Image URL to load.
    let url: URL?
    // Closure for the final image content view.
    let content: (Image) -> Content
    // Placeholder closure while loading.
    let placeholder: () -> Placeholder
    
    // Loaded image, once available.
    @State private var image: Image?
    // True while loading.
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
                // Show loaded image.
                content(image)
            } else if isLoading {
                // Show placeholder while loading.
                placeholder()
            } else {
                // Start loading when placeholder appears.
                placeholder()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    // Loads the image (simulated here; replace with actual image/network loading).
    private func loadImage() {
        guard url != nil, !isLoading else { return }
        
        isLoading = true
        
        // Simulate async image loading on a background thread.
        DispatchQueue.global(qos: .userInitiated).async {
            // In a real app, replace this with data fetch and image decode.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Use a placeholder system image for demonstration.
                self.image = Image(systemName: "photo")
                self.isLoading = false
            }
        }
    }
}
