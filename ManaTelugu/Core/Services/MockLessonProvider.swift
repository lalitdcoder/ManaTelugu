import Foundation

final class MockLessonProvider {
    static let shared = MockLessonProvider()

    private init() {}

    // MARK: - Load Mock Lesson Response for Module
    func loadMockLesson(forModuleId moduleId: String, title: String = "Greetings & నమస్కారం") -> LessonResponse {
        let jsonString = """
        {
          "title": "\(title)",
          "objective": "Learn polite greetings and introduction phrases in Telugu",
          "estimated_minutes": 10,
          "activities": [
            {
              "type": "introduction",
              "title": "Welcome to Telugu Greetings",
              "instruction": "Listen and observe the polite greeting sound.",
              "prompt": "నమస్కారం (Namaskāram) is the traditional polite Telugu greeting used when meeting someone.",
              "telugu_text": "నమస్కారం",
              "transliteration": "Namaskāram",
              "english_translation": "Hello / Greetings",
              "explanation": "Derived from Sanskrit, Namaskaram conveys deep respect."
            },
            {
              "type": "vocabulary",
              "title": "Essential Greeting Words",
              "instruction": "Study these common Telugu greeting terms.",
              "prompt": "Tap each item to learn its pronunciation and English meaning.",
              "options": ["నమస్కారం • Hello", "ఎలా ఉన్నారు? • How are you?", "బాగున్నాను • I am fine", "ధన్యవాదాలు • Thank you"],
              "explanation": "These four phrases form the baseline of everyday Telugu etiquette."
            },
            {
              "type": "multiple_choice",
              "title": "Choose the Correct Greeting",
              "instruction": "Select the appropriate phrase for 'Hello'.",
              "prompt": "How do you say 'Hello' politely in Telugu?",
              "options": ["నమస్కారం (Namaskāram)", "ధన్యవాదాలు (Dhanyavādālu)", "వస్తున్నాను (Vastunnānu)", "శుభోదయం (Shubhōdayam)"],
              "answer": "నమస్కారం (Namaskāram)",
              "explanation": "నమస్కారం is the universal polite greeting."
            },
            {
              "type": "matching",
              "title": "Match Telugu to English",
              "instruction": "Connect the Telugu phrase to its correct English translation.",
              "prompt": "Match all pairs correctly to continue.",
              "options": ["నమస్కారం", "Hello", "ధన్యవాదాలు", "Thank you", "బాగున్నాను", "I am fine"],
              "explanation": "Matching strengthens visual script recognition."
            },
            {
              "type": "listening",
              "title": "Listening Comprehension",
              "instruction": "Listen closely to the spoken clip.",
              "prompt": "What phrase was spoken in the audio clip?",
              "telugu_text": "బాగున్నాను",
              "transliteration": "Bāgunnānu",
              "options": ["I am fine (బాగున్నాను)", "Hello (నమస్కారం)", "Thank you (ధన్యవాదాలు)"],
              "answer": "I am fine (బాగున్నాను)",
              "explanation": "Bāgunnānu literally means 'I am in a good state'."
            },
            {
              "type": "sentence_builder",
              "title": "Sentence Construction",
              "instruction": "Arrange the words to form 'Hello! How are you?'",
              "prompt": "Tap the words in correct order:",
              "options": ["ఎలా", "నమస్కారం!", "ఉన్నారు?"],
              "answer": "నమస్కారం! ఎలా ఉన్నారు?",
              "explanation": "Polite conversations start with Namaskaram followed by Elā unnāru?"
            },
            {
              "type": "fill_blank",
              "title": "Fill in the Missing Word",
              "instruction": "Complete the polite response.",
              "prompt": "నేను ____ (I am fine).",
              "options": ["బాగున్నాను", "నమస్కారం", "వెళ్తున్నాను"],
              "answer": "బాగున్నాను",
              "explanation": "Nēnu bāgunnānu means 'I am doing well'."
            },
            {
              "type": "translation",
              "title": "Translate to English",
              "instruction": "Translate the sentence into English.",
              "prompt": "ధన్యవాదాలు, నేను బాగున్నాను.",
              "telugu_text": "ధన్యవాదాలు, నేను బాగున్నాను.",
              "transliteration": "Dhanyavādālu, nēnu bāgunnānu.",
              "options": ["Thank you, I am fine.", "Hello, how are you?", "Good morning, see you soon."],
              "answer": "Thank you, I am fine.",
              "explanation": "Dhanyavādālu = Thank you, nēnu bāgunnānu = I am fine."
            },
            {
              "type": "conversation",
              "title": "Real Mini-Dialogue",
              "instruction": "Follow the two-person dialogue.",
              "prompt": "Person A: నమస్కారం! ఎలా ఉన్నారు?\\nPerson B: నమస్కారం! నేను బాగున్నాను, ధన్యవాదాలు.",
              "telugu_text": "నమస్కారం! ఎలా ఉన్నారు?",
              "english_translation": "A: Hello! How are you?\\nB: Hello! I am fine, thank you.",
              "explanation": "Notice how both speakers exchange Namaskaram as respect."
            },
            {
              "type": "review",
              "title": "Module Review Summary",
              "instruction": "Review core takeaways before completing.",
              "prompt": "You have mastered: Namaskaram, Elā unnāru, Bāgunnānu, and Dhanyavādālu!",
              "explanation": "Great job! You are ready to speak polite Telugu greetings."
            }
          ]
        }
        """

        do {
            let data = jsonString.data(using: .utf8)!
            let lesson = try JSONDecoder().decode(LessonResponse.self, from: data)
            return lesson
        } catch {
            print("❌ Error decoding mock lesson JSON: \(error)")
            return LessonResponse(
                title: title,
                objective: "Learn basic Telugu phrases",
                estimatedMinutes: 10,
                activities: [
                    EngineLessonActivity(
                        type: .introduction,
                        title: "Welcome",
                        instruction: "Introduction to Telugu",
                        contentIds: nil,
                        prompt: "Welcome to \(title)!",
                        teluguText: "నమస్కారం",
                        transliteration: "Namaskāram",
                        englishTranslation: "Hello",
                        options: nil,
                        answer: nil,
                        explanation: nil
                    )
                ]
            )
        }
    }
}
