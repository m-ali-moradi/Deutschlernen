# Deutschmate - German Learning App

**Deutschmate** is a premium, comprehensive German learning platform that guides users from **A1 to C1 levels**. It combines **in-depth grammar lessons** with interactive exercises, a curated list of most used words, and essential real-world dialogues.

## Features

### Learning Categories
- **Grammar**: Over 75 structured lessons covering all CEFR levels (A1 to C1), modularized into granular topic files for lightning-fast loading and better organization.
- **Vocabulary**: Over 2,500 most common words with an interactive flashcard study mode and SRS-inspired retention system.
- **Dialogues**: Immersive practice scenarios (doctor appointments, workplace communication, city registration) with Text-to-Speech (TTS) and bilingual support.
- **Practice**: A rich collection of exercises and exam preparation guides for **telc, Goethe, and ÖSD**.

### Smart Experience
- **Seamless Onboarding**: A high-impact multi-slide intro that initializes assets in the background, ensuring a smooth first impression.
- **Offline First**: All core lessons and progress are stored locally using a robust **Drift/SQLite** database with **Write-Ahead Logging (WAL)** for high-performance concurrent access.
- **Progress Tracking**: Dynamic XP calculations, weekly targets (volume + accuracy), achievement system, and automated weak-area identification.
- **Interactive Flashcards**: Advanced spaced-repetition study system with customizable difficulty and favorite tracking.

### Architecture & Tech Stack
- **Flutter**: Modern, high-performance cross-platform development.
- **Riverpod**: Declarative state management and dependency injection across features.
- **Drift (SQLite)**: Core persistence layer with advanced migrations and indexing for scalability.
- **Clean Architecture**: Disciplined separation of features, core logic, and UI components.
- **Content Infrastructure**: Asset-to-Database synchronization pipeline for efficient handling of large-scale pedagogical content.

## Project Structure
- `lib/core`: Essential infrastructure: database schemas, content loading services, theme tokens, and global bootstrap logic.
- `lib/features`: Feature-sliced modules (Grammar, Vocabulary, Practice, Home, Onboarding, Profile).
- `lib/shared`: Reusable design system components, layout primitives, and localization utilities.
- `assets/content`: Granular JSON data store for curriculum content, structured by level and topic.

## Getting Started

### Prerequisites
- Flutter SDK (stable)
- Dart SDK

### Installation
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` to launch the app.

### Maintenance
- `dart analyze`: Maintain high code quality.
- `dart format .`: Keep the codebase consistent.

## Contact & Support
For any questions, bug reports, or feature requests, contact: [alimoradi20252@gmail.com](mailto:alimoradi20252@gmail.com).

## License
This project is licensed under the MIT License.



