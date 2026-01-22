import Foundation

/// Debug logging utility that only logs in DEBUG builds
struct DebugLogger {
    static func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):\(line)] \(function) - \(message)")
        #endif
    }
    
    static func logError(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("❌ [\(fileName):\(line)] \(function) - ERROR: \(message)")
        #endif
    }
    
    static func logWarning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("⚠️ [\(fileName):\(line)] \(function) - WARNING: \(message)")
        #endif
    }
}
