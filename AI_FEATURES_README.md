# AI Features for Mana Telugu

This document describes the AI-powered features integrated into the Mana Telugu learning app using the Gemini API.

## Features Implemented

### 1. Interactive Conversational Practice
- **Location**: `Features/AI/ConversationalPracticeView.swift`
- **Service**: `Core/Services/GeminiService.swift` + `Core/Services/SpeechService.swift`
- **Features**:
  - Real-time speech-to-text recognition for Telugu
  - AI-powered conversation responses in Telugu
  - Instant grammar and vocabulary corrections
  - Contextual suggestions for better expressions
  - Topic-based conversation starters
  - Text-to-speech for AI responses

### 2. Personalized Vocabulary Trainer
- **Location**: `Features/AI/PersonalizedVocabularyTrainerView.swift`
- **Service**: `Core/Services/GeminiService.swift`
- **Features**:
  - AI-generated quizzes based on user learning patterns
  - Adaptive difficulty levels (beginner, intermediate, advanced)
  - Context-based example sentences
  - Mistake pattern analysis
  - Performance tracking and analytics
  - Personalized word recommendations

### 3. AI Learning Hub
- **Location**: `Features/AI/AIHubView.swift`
- **Features**:
  - Centralized access to all AI features
  - Learning analytics and progress tracking
  - AI insights and recommendations
  - Feature overview and navigation

## Technical Implementation

### Services Architecture

#### GeminiService
- Handles all AI API communications
- Implements conversation generation
- Manages vocabulary quiz creation
- Provides learning pattern analysis
- Uses Gemini 2.5 Flash model for optimal performance

#### SpeechService
- Manages speech-to-text recognition
- Handles text-to-speech synthesis
- Provides audio session management
- Supports Telugu language recognition
- Implements permission handling

### Integration Points

#### AppSession Updates
- Added GeminiService and SpeechService to AppSession
- Centralized service management
- Environment object distribution

#### PracticeView Integration
- Added AI Features section
- Navigation to new AI-powered features
- Maintains existing practice activities

#### Permissions
- Added microphone usage description
- Added speech recognition usage description
- Proper permission request handling

## API Configuration

### Gemini API
- **API Key**: `AIzaSyC7tBA1pkwtzSa4SGNCVY5ljAeh_QrkAqE`
- **Model**: `gemini-2.5-flash`
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent`

### Speech Recognition
- **Language**: Telugu (India) - `te-IN`
- **Framework**: Speech Framework
- **Audio Engine**: AVAudioEngine

## Usage Instructions

### For Conversational Practice:
1. Navigate to Practice → AI Conversation Practice
2. Grant microphone and speech recognition permissions
3. Choose a conversation topic or start freely
4. Speak in Telugu or type your message
5. Receive AI feedback and corrections

### For Vocabulary Training:
1. Navigate to Practice → Personalized Vocabulary Trainer
2. Select your difficulty level
3. Generate a personalized quiz
4. Answer vocabulary questions with context
5. Review performance and get recommendations

### For AI Hub:
1. Navigate to Practice → AI Learning Hub
2. View all AI features in one place
3. Track learning analytics
4. Access AI insights and recommendations

## Future Enhancements

The following features are planned for future releases:
- Grammar Assistant with AI explanations
- Cultural Context learning with stories
- Writing Practice with AI feedback
- Advanced pronunciation analysis
- Personalized learning paths

## Performance Considerations

- AI responses are optimized for mobile performance
- Speech recognition works offline for basic functionality
- Caching mechanisms for frequently used responses
- Efficient memory management for conversation history
- Background processing for analytics

## Security & Privacy

- API key is embedded in the app (consider moving to secure storage for production)
- User conversations are processed by Gemini API
- No persistent storage of conversation content
- Local analytics and progress tracking
- Permission-based feature access
