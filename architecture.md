# App Architecture

## 1. Architectural Pattern: Feature-Based Clean Architecture
The application follows a **Feature-Based Clean Architecture** pattern to promote separation of concerns, testability, and maintainability.

### Core & Cross-Cutting Concerns
- **Core:** Contains global themes, typography, and styling logic (`lib/core/`).
- **Data & Domain:** Shared fundamental business objects and repositories are located in the top-level `domain/` and `data/` directories, keeping them independent of the UI features.

### Feature Modules (`lib/features/`)
The Presentation layer is organized entirely by features (e.g., `library`, `reader`).
Each feature module contains its own:
- **Screens:** UI specific to this feature.
- **Widgets:** Reusable components specific to this feature.
- **State Management:** (Optional) Specific business logic/controllers.

---

## 2. State Management
The project uses **ValueNotifier** (and natively reactive tools like `AnimatedBuilder`/`ValueListenableBuilder`) for lightweight state management and theme switching. Future complex states should use a modern provider like Riverpod or Bloc encapsulated within their respective features.

---

## 3. Directory Structure

```text
lib/
├── core/
│   ├── theme/             # Global themes, typography, and styling logic
├── data/
│   └── repositories/      # Implementation of data fetching/storage logic (e.g. LocalEpubRepository)
├── domain/
│   ├── entities/          # Core business logic objects (e.g. EpubBook, EpubChapter)
│   └── repositories/      # Interfaces for repositories
├── features/
│   ├── library/           # The Library feature module
│   │   └── screens/       # UI screens specific to this feature (e.g. home_page.dart)
│   └── reader/            # The Reader feature module
│       └── screens/       # UI screens specific to this feature (e.g. reader_page.dart)
└── main.dart              # Application entry point
```

## 4. Future Agent Instructions

If you are an AI assistant contributing to this codebase, please adhere to the following rules:

1. **Feature Encapsulation**: When adding a completely new feature (e.g., "Settings", "Bookmarks", "Store"), create a new folder under `lib/features/`.
2. **UI Segregation**: Place all screens inside `lib/features/<feature_name>/screens/`. Do not create top-level `ui` or `presentation` directories.
3. **Domain & Data**: Keep fundamental business objects (entities, models) and remote/local repository implementations in the top-level `domain/` and `data/` directories if they are shared across multiple features.
4. **Theme**: Modify `lib/core/theme/app_theme.dart` when requested to change colors or global typography.
5. **Imports**: Use relative imports to cross between features and the `core`, `domain`, and `data` directories to ensure seamless project compilability. Avoid absolute package imports for internal repo files unless strictly necessary.

---

## 5. Core Parsing Flow
The core functionality of reading an EPUB relies on the following parsing flow:
1. **File Picker:** The user selects an EPUB file via a file picker dialogue.
2. **Temp Unzip:** The selected `.epub` file (which is a zipped archive) is extracted into a temporary directory on the device.
3. **Metadata Extraction:** The app parses the `container.xml` and package documents (`.opf`) to extract metadata (Title, Author, Cover Image) and the reading order (spine/table of contents).
4. **WebView Render:** The extracted XHTML/HTML content is loaded and rendered within a WebView widget.
