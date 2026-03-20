# Deutschlernen - German Learning App

**Deutschlernen** is a comprehensive German learning platform that guides users from **A1 to C1 levels**. It combines **in-depth grammar lessons** with exercises and a specialized focus on **business and professional vocabulary**, helping users master the language for career success through interactive exercises and smart flashcards.

## Features

### 📚 Learning Categories
- **Grammar**: 62 structured lessons covering all CEFR levels (A1, A2, B1, B2, C1).
- **Exercises**: Over 180 hand-crafted exercises linked directly to grammar topics.
- **Vocabulary**: Professional and business-focused word lists with flashcard study mode.
- **Phrases**: Practical expressions for workplace communication and daily life.

### 🚀 Smart Experience
- **Onboarding Guide**: A quick start guide for new users to introduce core features.
- **Progress Tracking**: Real-time XP, level tracking, and weekly goals.
- **Offline First**: All lessons and progress are stored locally using a Drift/SQLite database.
- **Flashcards**: Interactive study system for effective vocabulary learning.

### 🛠️ Architecture & Tech Stack
- **Flutter**: Cross-platform mobile development.
- **Riverpod**: Robust state management and dependency injection.
- **Drift (SQLite)**: Core database for offline storage and persistence.
- **GoRouter**: Declarative routing system with onboarding support.
- **Clean Architecture**: Separation of features, core, and shared layers.

## Project Structure
- `lib/core`: Core logic, database, theme, and content services.
- `lib/features`: Feature-based modules (Exercises, Grammar, Home, Onboarding, Profile, Vocabulary).
- `lib/shared`: Shared widgets, localization, and utilities.
- `assets/content`: JSON data for grammar lessons and vocabulary.

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK

### Installation
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` to launch the app on your device or emulator.

## Development

### Documentation
The codebase follows official Dart documentation standards. Comments are written in **simple B1-level English** to ensure clarity for all contributors.

### Maintenance
- `dart analyze`: Check for code quality and lints.
- `dart format .`: Ensure consistent code formatting.

## Future Plans
Currently, the application relies exclusively on built-in offline content. Future updates will introduce **AI integration** to provide a highly personalized learning experience, alongside real-time synchronization with an expanding library of online content.

## Support
For any questions, bug reports, or feature requests, please contact the developer at: [alimoradi20252@gmail.com](mailto:alimoradi20252@gmail.com).

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


