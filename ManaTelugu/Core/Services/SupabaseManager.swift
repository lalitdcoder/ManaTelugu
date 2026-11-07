import Foundation

@MainActor
final class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()

    // MARK: - Configuration
    static let supabaseURLString = "https://bvwtnqhpwjvllyweevjn.supabase.co"
    static let supabasePublishableKey = "sb_publishable_Ueqfox0hAhhfGeYsR3KV7A_oJOGseu9"
    static let supabaseJWKSURLString = "https://bvwtnqhpwjvllyweevjn.supabase.co/auth/v1/.well-known/jwks.json"

    @Published var currentUserId: String? = nil
    @Published var isAuthenticated: Bool = false
    @Published var lastError: String? = nil

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        config.timeoutIntervalForResource = 30.0
        self.session = URLSession(configuration: config)

        if let storedId = UserDefaults.standard.string(forKey: "supabase_user_id"), UUID(uuidString: storedId) != nil {
            self.currentUserId = storedId
        } else {
            let newId = UUID().uuidString.lowercased()
            UserDefaults.standard.set(newId, forKey: "supabase_user_id")
            self.currentUserId = newId
        }
        self.isAuthenticated = true
    }

    // MARK: - HTTP Request Helper
    private func makeRequest(endpoint: String, method: String = "GET", body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: "\(Self.supabaseURLString)\(endpoint)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(Self.supabasePublishableKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(Self.supabasePublishableKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body = body {
            request.httpBody = body
        }

        return request
    }

    // MARK: - Diagnostic Safe Logging
    private func logDiagnosticInfo(request: URLRequest, response: URLResponse?, data: Data?) {
        let httpResponse = response as? HTTPURLResponse
        let statusCode = httpResponse?.statusCode ?? -1
        let endpoint = request.url?.path ?? "unknown"
        let method = request.httpMethod ?? "GET"

        let requestBodyStr: String
        if let bodyData = request.httpBody, let str = String(data: bodyData, encoding: .utf8) {
            requestBodyStr = redactSecrets(str)
        } else {
            requestBodyStr = "(none)"
        }

        let responseBodyStr: String
        if let respData = data, let str = String(data: respData, encoding: .utf8) {
            responseBodyStr = redactSecrets(str)
        } else {
            responseBodyStr = "(empty response body)"
        }

        print("--- [SUPABASE DIAGNOSTICS] ---")
        print("▶️ Endpoint: \(method) \(endpoint)")
        print("▶️ Status Code: \(statusCode)")
        print("▶️ Request Body: \(requestBodyStr)")
        print("▶️ Response Body: \(responseBodyStr)")
        print("-------------------------------")
    }

    private func redactSecrets(_ input: String) -> String {
        var clean = input
        clean = clean.replacingOccurrences(of: Self.supabasePublishableKey, with: "[REDACTED_API_KEY]")
        return clean
    }

    // MARK: - REST API Database Query
    func fetch<T: Decodable>(table: String, queryItems: [URLQueryItem] = []) async throws -> [T] {
        var components = URLComponents(string: "\(Self.supabaseURLString)/rest/v1/\(table)")
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Self.supabasePublishableKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(Self.supabasePublishableKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

        if !(200...299).contains(statusCode) {
            logDiagnosticInfo(request: request, response: response, data: data)
            let responseString = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "SupabaseError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(statusCode): \(responseString)"])
        }

        let decoder = JSONDecoder()
        return try decoder.decode([T].self, from: data)
    }

    // MARK: - Edge Function Invocation
    func generateLesson(moduleId: String) async throws -> GeneratedLesson {
        struct Payload: Encodable {
            let module_id: String
            let user_id: String?
        }

        let payload = Payload(module_id: moduleId, user_id: currentUserId)
        let bodyData = try JSONEncoder().encode(payload)

        let request = try makeRequest(endpoint: "/functions/v1/generate-lesson", method: "POST", body: bodyData)
        let (data, response) = try await session.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

        logDiagnosticInfo(request: request, response: response, data: data)

        guard (200...299).contains(statusCode) else {
            let responseString = String(data: data, encoding: .utf8) ?? "No response body"
            throw NSError(domain: "SupabaseEdgeFunctionError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Edge Function returned HTTP \(statusCode): \(responseString)"])
        }

        let decoder = JSONDecoder()
        return try decoder.decode(GeneratedLesson.self, from: data)
    }

    // MARK: - Record Lesson Attempt
    func recordLessonAttempt(moduleId: String, score: Double, xpEarned: Int) async {
        struct AttemptPayload: Encodable {
            let user_id: String
            let lesson_id: String
            let score: Double
            let completed_at: String
        }

        guard let userId = currentUserId else { return }

        let formatter = ISO8601DateFormatter()
        let payload = AttemptPayload(
            user_id: userId,
            lesson_id: moduleId,
            score: score,
            completed_at: formatter.string(from: Date())
        )

        do {
            let bodyData = try JSONEncoder().encode(payload)
            let request = try makeRequest(endpoint: "/rest/v1/lesson_attempts", method: "POST", body: bodyData)
            let (data, response) = try await session.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

            logDiagnosticInfo(request: request, response: response, data: data)

            if (200...299).contains(statusCode) {
                print("✅ Successfully recorded lesson attempt on Supabase.")
            } else {
                print("⚠️ Supabase lesson attempt POST returned status \(statusCode).")
            }
        } catch {
            print("⚠️ Could not sync lesson attempt to Supabase: \(error.localizedDescription)")
        }
    }
}
