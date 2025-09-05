import Foundation
import Combine

// MARK: - Gemini API Models
struct GeminiRequest: Codable {
    let contents: [Content]
    let generationConfig: GenerationConfig?
    let safetySettings: [SafetySetting]?
}

struct Content: Codable {
    let parts: [Part]
}

struct Part: Codable {
    let text: String
}

struct GenerationConfig: Codable {
    let temperature: Double?
    let topK: Int?
    let topP: Double?
    let maxOutputTokens: Int?
}

struct SafetySetting: Codable {
    let category: String
    let threshold: String
}

struct GeminiResponse: Codable {
    let candidates: [Candidate]?
    let error: GeminiError?
}

struct Candidate: Codable {
    let content: Content
    let finishReason: String?
}

struct GeminiError: Error, Codable {
    let code: Int
    let message: String
    let status: String
}

// MARK: - AI Conversation Models
struct ConversationMessage: Identifiable, Codable {
    var id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
    let corrections: [Correction]?
    let suggestions: [String]?
}

struct Correction: Codable {
    let original: String
    let corrected: String
    let explanation: String
}

// MARK: - Vocabulary Training Models
struct PersonalizedQuiz: Identifiable, Codable {
    var id = UUID()
    let words: [QuizWord]
    let difficulty: QuizDifficulty
    let theme: String
    let generatedAt: Date
}

struct QuizWord: Identifiable, Codable {
    var id = UUID()
    let telugu: String
    let transliteration: String
    let english: String
    let contextSentence: String
    let difficulty: WordDifficulty
}

enum QuizDifficulty: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
}

enum WordDifficulty: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
}

// MARK: - Learning Analytics
struct LearningPattern: Codable {
    let commonMistakes: [String: Int]
    let weakAreas: [String]
    let strongAreas: [String]
    let recommendedFocus: [String]
}

// MARK: - Gemini Service
class GeminiService: ObservableObject {
    static let shared = GeminiService()
    
    private let apiKey = "AIzaSyC7tBA1pkwtzSa4SGNCVY5ljAeh_QrkAqE"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var cancellables = Set<AnyCancellable>()
    private var lastRequestTime: Date?
    private let minimumRequestInterval: TimeInterval = 1.0 // 1 second between requests
    
    private init() {
        // Run AI health check on initialization
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.runAIHealthCheck()
        }
    }
    
    // MARK: - AI Health Check
    private func runAIHealthCheck() {
        print("🔍 Running AI Health Check...")
        
        // Test basic API connectivity
        testAPIConnection()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ API Connection Test Failed: \(error)")
                    }
                },
                receiveValue: { response in
                    print("✅ API Connection Test Successful: \(response)")
                    // If basic connection works, test AI features
                    self.testAIFeatures()
                }
            )
            .store(in: &cancellables)
    }
    
    private func testAIFeatures() {
        print("🧪 Testing AI Features...")
        
        // Test conversation AI
        testConversationAI()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        
        // Test vocabulary AI
        testVocabularyAI()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - API Health Check
    func testAPIConnection() -> AnyPublisher<String, Error> {
        let testPrompt = "Say 'Hello' in Telugu with English transliteration."
        let request = GeminiRequest(
            contents: [Content(parts: [Part(text: testPrompt)])],
            generationConfig: GenerationConfig(
                temperature: 0.3,
                topK: 20,
                topP: 0.8,
                maxOutputTokens: 100
            ),
            safetySettings: nil
        )
        
        return makeRequest(request, responseType: GeminiResponse.self)
            .tryMap { response in
                if let error = response.error {
                    throw error
                }
                
                guard let candidate = response.candidates?.first,
                      let content = candidate.content.parts.first else {
                    throw GeminiError(code: -1, message: "No response from API test", status: "NO_RESPONSE")
                }
                
                return content.text
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - AI Feature Testing
    func testConversationAI() -> AnyPublisher<ConversationMessage, Error> {
        print("🧪 Testing AI Conversation Feature...")
        let testMessage = "Hello, how are you?"
        let emptyHistory: [ConversationMessage] = []
        
        return generateConversationResponse(userMessage: testMessage, conversationHistory: emptyHistory)
            .handleEvents(
                receiveOutput: { response in
                    print("✅ AI Conversation Test Successful: \(response.text)")
                },
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ AI Conversation Test Failed: \(error)")
                    }
                }
            )
            .eraseToAnyPublisher()
    }
    
    func testVocabularyAI() -> AnyPublisher<PersonalizedQuiz, Error> {
        print("🧪 Testing AI Vocabulary Feature...")
        let testWeakAreas = ["greetings", "family"]
        let testMistakes = ["namaskaram": 2, "dhanyavadalu": 1]
        
        return generatePersonalizedQuiz(
            userLevel: .beginner,
            weakAreas: testWeakAreas,
            previousMistakes: testMistakes
        )
        .handleEvents(
            receiveOutput: { quiz in
                print("✅ AI Vocabulary Test Successful: Generated \(quiz.words.count) words for theme '\(quiz.theme)'")
            },
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ AI Vocabulary Test Failed: \(error)")
                }
            }
        )
        .eraseToAnyPublisher()
    }
    
    // MARK: - Core API Methods
    private func makeRequest<T: Codable>(_ request: GeminiRequest, responseType: T.Type) -> AnyPublisher<T, Error> {
        return makeRequestWithRetry(request, responseType: responseType, retryCount: 0)
    }
    
    private func makeRequestWithRetry<T: Codable>(_ request: GeminiRequest, responseType: T.Type, retryCount: Int) -> AnyPublisher<T, Error> {
        // Rate limiting
        if let lastRequest = lastRequestTime {
            let timeSinceLastRequest = Date().timeIntervalSince(lastRequest)
            if timeSinceLastRequest < minimumRequestInterval {
                let delay = minimumRequestInterval - timeSinceLastRequest
                print("Rate limiting: waiting \(delay) seconds before request")
                return Just(())
                    .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                    .flatMap { _ in
                        self.makeRequestWithRetry(request, responseType: responseType, retryCount: retryCount)
                    }
                    .eraseToAnyPublisher()
            }
        }
        
        lastRequestTime = Date()
        
        let urlString = "\(baseURL)?key=\(apiKey)"
        print("Gemini API URL (attempt \(retryCount + 1)): \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Failed to create URL from: \(urlString)")
            return Fail(error: GeminiError(code: -1, message: "Invalid URL", status: "INVALID_URL"))
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 30.0 // 30 second timeout
        
        do {
            let requestData = try JSONEncoder().encode(request)
            urlRequest.httpBody = requestData
            
            // Debug: Print request data
            if let requestString = String(data: requestData, encoding: .utf8) {
                print("Gemini API Request (attempt \(retryCount + 1)): \(requestString)")
            }
        } catch {
            print("Failed to encode request: \(error)")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .tryMap { data in
                // Debug: Print response data
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Gemini API Response (attempt \(retryCount + 1)): \(responseString)")
                }
                return data
            }
            .tryMap { data in
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    print("JSON Decoding Error (attempt \(retryCount + 1)): \(error)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Failed to decode JSON: \(responseString)")
                        
                        // Try to parse as a simple error response
                        if let errorData = responseString.data(using: .utf8),
                           let errorResponse = try? JSONDecoder().decode(GeminiError.self, from: errorData) {
                            print("Parsed as GeminiError: \(errorResponse)")
                            throw errorResponse
                        }
                    }
                    
                    // If it's a decoding error and we haven't retried yet, try again
                    if retryCount < 2 {
                        print("Retrying request due to decoding error...")
                        throw error
                    }
                    
                    // Create a more descriptive error
                    let descriptiveError = NSError(
                        domain: "GeminiService",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Failed to parse API response. This might be due to API changes or network issues.",
                            NSLocalizedFailureReasonErrorKey: error.localizedDescription
                        ]
                    )
                    throw descriptiveError
                }
            }
            .catch { error -> AnyPublisher<T, Error> in
                // Handle network errors with retry
                if retryCount < 2 {
                    print("Network error (attempt \(retryCount + 1)), retrying in 2 seconds...")
                    return Just(())
                        .delay(for: .seconds(2), scheduler: DispatchQueue.main)
                        .flatMap { _ in
                            self.makeRequestWithRetry(request, responseType: responseType, retryCount: retryCount + 1)
                        }
                        .eraseToAnyPublisher()
                }
                
                print("Max retries reached, giving up")
                return Fail(error: error).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Conversation Features
    func generateConversationResponse(userMessage: String, conversationHistory: [ConversationMessage]) -> AnyPublisher<ConversationMessage, Error> {
        isLoading = true
        errorMessage = nil
        
        let systemPrompt = """
        You are an expert Telugu language tutor and conversation partner. Your role is to:
        1. Respond naturally in Telugu to help learners practice conversation
        2. Provide gentle, encouraging corrections when learners make mistakes
        3. Offer helpful suggestions for better expressions and grammar
        4. Keep responses appropriate for language learners (clear, simple, educational)
        5. Always include both Telugu script and English transliteration in parentheses
        6. Be encouraging and supportive in your teaching approach
        7. Focus on practical, everyday Telugu conversation
        
        Important: Always respond in Telugu first, then provide English transliteration in parentheses.
        Example: "నమస్కారం! మీరు ఎలా ఉన్నారు? (Namaskāram! Mīru elā unnāru? - Hello! How are you?)"
        """
        
        let historyText = conversationHistory.suffix(5).map { msg in
            msg.isUser ? "User: \(msg.text)" : "Assistant: \(msg.text)"
        }.joined(separator: "\n")
        
        let prompt = """
        \(systemPrompt)
        
        Previous conversation:
        \(historyText)
        
        User's current message: \(userMessage)
        
        Please respond naturally in Telugu with English transliteration. If the user made any mistakes, gently correct them. Format your response as:
        
        RESPONSE: [Your natural Telugu response with English transliteration in parentheses]
        CORRECTIONS: [Any grammar/vocabulary corrections needed, or "None" if no corrections needed]
        SUGGESTIONS: [Helpful learning suggestions, or "None" if no suggestions needed]
        
        Remember: Be encouraging, educational, and focus on helping the learner improve their Telugu skills.
        """
        
        let request = GeminiRequest(
            contents: [Content(parts: [Part(text: prompt)])],
            generationConfig: GenerationConfig(
                temperature: 0.7,
                topK: 40,
                topP: 0.95,
                maxOutputTokens: 500
            ),
            safetySettings: [
                SafetySetting(category: "HARM_CATEGORY_HARASSMENT", threshold: "BLOCK_MEDIUM_AND_ABOVE"),
                SafetySetting(category: "HARM_CATEGORY_HATE_SPEECH", threshold: "BLOCK_MEDIUM_AND_ABOVE")
            ]
        )
        
        return makeRequest(request, responseType: GeminiResponse.self)
            .tryMap { response in
                print("Parsing Gemini response: \(response)")
                
                // Check for API errors first
                if let error = response.error {
                    print("Gemini API Error: \(error)")
                    throw GeminiError(code: error.code, message: error.message, status: error.status)
                }
                
                guard let candidate = response.candidates?.first else {
                    print("No candidates in response")
                    throw GeminiError(code: -1, message: "No response generated", status: "NO_RESPONSE")
                }
                
                guard let content = candidate.content.parts.first else {
                    print("No content parts in candidate")
                    throw GeminiError(code: -1, message: "No content in response", status: "NO_CONTENT")
                }
                
                print("Response text: \(content.text)")
                return self.parseConversationResponse(content.text)
            }
            .catch { error -> AnyPublisher<ConversationMessage, Error> in
                print("API call failed, providing fallback response: \(error)")
                // Provide a helpful fallback response when API fails
                let fallbackResponse = ConversationMessage(
                    text: "క్షమించండి, నేను ప్రస్తుతం సమాధానం ఇవ్వలేకపోతున్నాను. కానీ మీరు తెలుగు నేర్చుకోవడం కొనసాగించండి! (Kṣamiñcaṇḍi, nēnu prastutam samādhānaṁ ivvalēkapōtunnānu. Kāni mīru telugu nērcukōvaḍaṁ konasāgaciṇḍi! - Sorry, I can't respond right now. But please continue learning Telugu!)",
                    isUser: false,
                    timestamp: Date(),
                    corrections: nil,
                    suggestions: [
                        "Try typing your message again",
                        "Check your internet connection", 
                        "Practice with the vocabulary quiz",
                        "Try speaking in Telugu: 'నమస్కారం' (namaskāram - hello)"
                    ]
                )
                return Just(fallbackResponse)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .handleEvents(
                receiveCompletion: { _ in
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            )
            .eraseToAnyPublisher()
    }
    
    private func parseConversationResponse(_ responseText: String) -> ConversationMessage {
        print("Parsing conversation response: \(responseText)")
        
        let lines = responseText.components(separatedBy: "\n")
        var response = ""
        var corrections: [Correction] = []
        var suggestions: [String] = []
        
        for line in lines {
            if line.hasPrefix("RESPONSE:") {
                response = String(line.dropFirst(9)).trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("CORRECTIONS:") {
                let correctionText = String(line.dropFirst(12)).trimmingCharacters(in: .whitespaces)
                if correctionText != "None" && !correctionText.isEmpty {
                    // Parse corrections (simplified for now)
                    corrections.append(Correction(
                        original: "User input",
                        corrected: correctionText,
                        explanation: "Grammar or vocabulary improvement"
                    ))
                }
            } else if line.hasPrefix("SUGGESTIONS:") {
                let suggestionText = String(line.dropFirst(12)).trimmingCharacters(in: .whitespaces)
                if suggestionText != "None" && !suggestionText.isEmpty {
                    suggestions = suggestionText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                }
            }
        }
        
        // If no structured response was found, use the entire text as the response
        if response.isEmpty {
            response = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
            print("Using fallback response: \(response)")
        }
        
        // Ensure we have a response
        if response.isEmpty {
            response = "I'm sorry, I couldn't process your message. Please try again."
            print("Using default fallback response")
        }
        
        print("Parsed response: \(response)")
        
        return ConversationMessage(
            text: response,
            isUser: false,
            timestamp: Date(),
            corrections: corrections.isEmpty ? nil : corrections,
            suggestions: suggestions.isEmpty ? nil : suggestions
        )
    }
    
    // MARK: - Vocabulary Training Features
    func generatePersonalizedQuiz(userLevel: QuizDifficulty, weakAreas: [String], previousMistakes: [String: Int]) -> AnyPublisher<PersonalizedQuiz, Error> {
        isLoading = true
        errorMessage = nil
        
        let prompt = """
        You are an expert Telugu language tutor creating a personalized vocabulary quiz.
        
        Learner Level: \(userLevel.rawValue)
        Weak Areas: \(weakAreas.isEmpty ? "General vocabulary" : weakAreas.joined(separator: ", "))
        Common Mistakes: \(previousMistakes.isEmpty ? "None recorded" : previousMistakes.map { "\($0.key): \($0.value) times" }.joined(separator: ", "))
        
        Create 8-10 Telugu vocabulary words that are:
        - Appropriate for \(userLevel.rawValue) level
        - Focus on practical, everyday words
        - Address the learner's weak areas
        - Include common words that are frequently used
        
        For each word, provide:
        1. Telugu word in Telugu script
        2. Accurate English transliteration
        3. Clear English meaning
        4. Simple context sentence in Telugu with English translation
        5. Appropriate difficulty level
        
        Format as valid JSON:
        {
            "words": [
                {
                    "telugu": "తెలుగు_వర్డ్",
                    "transliteration": "accurate_transliteration",
                    "english": "Clear English meaning",
                    "contextSentence": "Simple Telugu sentence using the word",
                    "difficulty": "easy"
                }
            ],
            "theme": "Descriptive theme name for this quiz"
        }
        
        Ensure the JSON is valid and all fields are properly filled.
        """
        
        let request = GeminiRequest(
            contents: [Content(parts: [Part(text: prompt)])],
            generationConfig: GenerationConfig(
                temperature: 0.8,
                topK: 40,
                topP: 0.95,
                maxOutputTokens: 1000
            ),
            safetySettings: nil
        )
        
        return makeRequest(request, responseType: GeminiResponse.self)
            .tryMap { response in
                print("Parsing quiz response: \(response)")
                
                // Check for API errors first
                if let error = response.error {
                    print("Gemini API Error: \(error)")
                    throw GeminiError(code: error.code, message: error.message, status: error.status)
                }
                
                guard let candidate = response.candidates?.first else {
                    print("No candidates in quiz response")
                    throw GeminiError(code: -1, message: "No quiz generated", status: "NO_RESPONSE")
                }
                
                guard let content = candidate.content.parts.first else {
                    print("No content parts in quiz candidate")
                    throw GeminiError(code: -1, message: "No content in quiz response", status: "NO_CONTENT")
                }
                
                print("Quiz response text: \(content.text)")
                return try self.parseQuizResponse(content.text, userLevel: userLevel)
            }
            .catch { error -> AnyPublisher<PersonalizedQuiz, Error> in
                print("Quiz API call failed, providing fallback quiz: \(error)")
                // Provide a comprehensive fallback quiz when API fails
                let fallbackQuiz = PersonalizedQuiz(
                    words: [
                        QuizWord(
                            telugu: "నమస్కారం",
                            transliteration: "namaskāram",
                            english: "Hello/Greetings",
                            contextSentence: "నమస్కారం, మీరు ఎలా ఉన్నారు? (Hello, how are you?)",
                            difficulty: .easy
                        ),
                        QuizWord(
                            telugu: "ధన్యవాదాలు",
                            transliteration: "dhanyavādālu",
                            english: "Thank you",
                            contextSentence: "మీ సహాయానికి ధన్యవాదాలు. (Thank you for your help.)",
                            difficulty: .easy
                        ),
                        QuizWord(
                            telugu: "క్షమించండి",
                            transliteration: "kṣamiñcaṇḍi",
                            english: "Sorry/Excuse me",
                            contextSentence: "క్షమించండి, నేను ఆలస్యం అయ్యాను. (Sorry, I am late.)",
                            difficulty: .medium
                        ),
                        QuizWord(
                            telugu: "మంచిది",
                            transliteration: "mañcidi",
                            english: "Good/Fine",
                            contextSentence: "అది మంచిది. (That is good.)",
                            difficulty: .easy
                        ),
                        QuizWord(
                            telugu: "ఇల్లు",
                            transliteration: "illu",
                            english: "House/Home",
                            contextSentence: "మా ఇల్లు చాలా పెద్దది. (Our house is very big.)",
                            difficulty: .easy
                        )
                    ],
                    difficulty: .beginner,
                    theme: "Essential Telugu Words",
                    generatedAt: Date()
                )
                return Just(fallbackQuiz)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .handleEvents(
                receiveCompletion: { _ in
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            )
            .eraseToAnyPublisher()
    }
    
    private func parseQuizResponse(_ responseText: String, userLevel: QuizDifficulty) throws -> PersonalizedQuiz {
        // Extract JSON from response
        let jsonStart = responseText.range(of: "{")
        let jsonEnd = responseText.range(of: "}", options: .backwards)
        
        guard let start = jsonStart?.lowerBound,
              let end = jsonEnd?.upperBound else {
            throw GeminiError(code: -1, message: "Invalid JSON format", status: "INVALID_JSON")
        }
        
        let jsonString = String(responseText[start..<end])
        let jsonData = jsonString.data(using: .utf8)!
        
        struct QuizResponse: Codable {
            let words: [QuizWordResponse]
            let theme: String
        }
        
        struct QuizWordResponse: Codable {
            let telugu: String
            let transliteration: String
            let english: String
            let contextSentence: String
            let difficulty: String
        }
        
        let quizResponse = try JSONDecoder().decode(QuizResponse.self, from: jsonData)
        
        let words = quizResponse.words.map { wordResponse in
            QuizWord(
                telugu: wordResponse.telugu,
                transliteration: wordResponse.transliteration,
                english: wordResponse.english,
                contextSentence: wordResponse.contextSentence,
                difficulty: WordDifficulty(rawValue: wordResponse.difficulty) ?? .medium
            )
        }
        
        return PersonalizedQuiz(
            words: words,
            difficulty: userLevel,
            theme: quizResponse.theme,
            generatedAt: Date()
        )
    }
    
    // MARK: - Learning Analytics
    func analyzeLearningPatterns(conversationHistory: [ConversationMessage], quizResults: [String: Bool]) -> AnyPublisher<LearningPattern, Error> {
        isLoading = true
        errorMessage = nil
        
        let mistakes = conversationHistory.compactMap { $0.corrections }.flatMap { $0 }
        let mistakeCounts = Dictionary(grouping: mistakes, by: { $0.original })
            .mapValues { $0.count }
        
        let prompt = """
        Analyze the following Telugu learning data and provide insights:
        
        Conversation mistakes: \(mistakeCounts)
        Quiz results: \(quizResults)
        
        Provide analysis in JSON format:
        {
            "commonMistakes": {"mistake": count},
            "weakAreas": ["area1", "area2"],
            "strongAreas": ["area1", "area2"],
            "recommendedFocus": ["focus1", "focus2"]
        }
        """
        
        let request = GeminiRequest(
            contents: [Content(parts: [Part(text: prompt)])],
            generationConfig: GenerationConfig(
                temperature: 0.3,
                topK: 20,
                topP: 0.8,
                maxOutputTokens: 500
            ),
            safetySettings: nil
        )
        
        return makeRequest(request, responseType: GeminiResponse.self)
            .tryMap { response in
                guard let candidate = response.candidates?.first,
                      let content = candidate.content.parts.first else {
                    throw GeminiError(code: -1, message: "No analysis generated", status: "NO_RESPONSE")
                }
                
                return try self.parseLearningPattern(content.text)
            }
            .handleEvents(
                receiveCompletion: { _ in
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            )
            .eraseToAnyPublisher()
    }
    
    private func parseLearningPattern(_ responseText: String) throws -> LearningPattern {
        let jsonStart = responseText.range(of: "{")
        let jsonEnd = responseText.range(of: "}", options: .backwards)
        
        guard let start = jsonStart?.lowerBound,
              let end = jsonEnd?.upperBound else {
            throw GeminiError(code: -1, message: "Invalid JSON format", status: "INVALID_JSON")
        }
        
        let jsonString = String(responseText[start..<end])
        let jsonData = jsonString.data(using: .utf8)!
        
        return try JSONDecoder().decode(LearningPattern.self, from: jsonData)
    }
}
