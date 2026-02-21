# 🇮🇳 Mana Telugu (మన తెలుగు)

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg?style=flat&logo=swift)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![UI Framework](https://img.shields.io/badge/UI-SwiftUI-informational?style=flat&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Design](https://img.shields.io/badge/Design-Apple%20HIG-black?style=flat&logo=apple)](https://developer.apple.com/design/human-interface-guidelines/)

**Mana Telugu** is a premium iOS application designed to make learning the Telugu language an engaging, joyful, and effective experience for beginners and children. Built with modern Apple technologies and a deep focus on gamification, it transforms language education into an interactive journey.

---

## ✨ Key Features

### 🔤 Alphabet Hub
- **Interactive Vowels & Consonants**: Comprehensive list of all Telugu characters.
- **Stroke Order Animations**: Visual guides to teach correct writing techniques.
- **Native Audio**: Clear pronunciation for every letter to perfect your accent.
- **Manual Progress**: Mark letters as learned to track your mastery.

### 📚 Structured Learning
- **Professional Lessons**: Step-by-step curriculum from basic greetings to complex sentences.
- **Storybook Hub**: Engaging stories with native narration and "read-along" highlighting.
- **Vocabulary Themes**: Words organized by categories like Animals, Colors, Family, and more.
- **Vocabulary Cards**: Spaced-repetition friendly cards with interactive audio.

### 🎮 Gamified Experience
- **Daily Streaks**: Maintain your learning momentum with a flame-style streak system.
- **XP & Levels**: Earn experience points for every activity and level up your Telugu skills.
- **Heart System**: Dynamic生命 system that regenerates over time, encouraging careful learning.
- **Leaderboards**: Compete with local users and track your ranking.
- **Badge Rewards**: Unlock beautiful, themed badges for reaching major milestones.
- **Treasure Chests**: Randomized rewards and stickers for consistent practice.

### 🎨 Premium Design & UX
- **Apple HIG Compliant**: A native feel that follows the latest Human Interface Guidelines.
- **Modern Aesthetics**: Vibrant gradients, glassmorphism, and smooth spring animations.
- **Dark Mode**: Fully optimized dark appearance for comfortable night-time learning.
- **Haptic Feedback**: Rich Taptic Engine integration for a "crunchy," responsive UI.
- **Accessibility**: First-class support for VoiceOver, dynamic type, and high contrast.

---

## 🏗️ Technical Architecture

The app follows a modern modular architecture designed for performance and maintainability:

- **Core**: Contains the central `AppSession`, global services (Haptics, Audio, Gamification), and persistence logic.
- **Features**: Highly encapsulated modules for each app section (Home, Alphabet, Lessons, Games, etc.).
- **Services**: Dedicated providers for data fetching, notification scheduling, and progress tracking.
- **Design System**: A robust collection of reusable UI components and tokens (`AppleHIGDesign`).

### Directory Structure
```text
ManaTelugu/
├── Core/               # App-wide state, Services, and Models
│   ├── Services/       # Gamification, Haptics, Audio, etc.
│   └── Models/         # Core data structures (User, Lesson, Word)
├── Features/           # Functional modules
│   ├── Home/           # Dashboard & Progress Metrics
│   ├── Alphabet/       # Learning Hub & Stroke Animations
│   ├── Lessons/        # Structured Curriculum
│   ├── Games/          # Interactive Learning Games
│   └── ParentMode/     # Specialized controls for guardians
└── Resources/          # Assets, Fonts, and Localized Content
```

---

## 🚀 Getting Started

### Prerequisites
- **Xcode 15.0+**
- **iOS 17.0+** (Simulator or Physical Device)
- **Swift 5.9+**

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ManaTelugu.git
   ```
2. Open `ManaTelugu.xcodeproj` in Xcode.
3. Ensure the active scheme is set to `ManaTelugu`.
4. Press `Cmd + R` to build and run!

---

## 🛠️ Development

### Design System
We use a custom design system defined in `AppleHIGDesignSystem.swift`. Use the provided tokens for spacing, typography, and colors to maintain consistency:
```swift
Text("Sample")
    .font(AppleHIGDesign.Typography.headline)
    .foregroundColor(AppleHIGDesign.Colors.primary)
```

### Gamification Integration
To award XP or update progress, use the `AppSession`:
```swift
session.awardXP(50, type: .lessonCompleted)
```

---

## 📜 License
*Add your license information here.*

---

## 👩‍💻 Authors
Developed with ❤️ by the **Mana Telugu Team**.
Special thanks to the Google DeepMind team and the Advanced Agentic Coding project.

---
*Learn Telugu with Joy. మన తెలుగుతో ఆనందంగా తెలుగు నేర్చుకోండి!*