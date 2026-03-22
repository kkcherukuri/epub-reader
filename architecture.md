# App Architecture

## 1. Architectural Pattern: Clean Architecture
The application follows the **Clean Architecture** pattern to promote separation of concerns, testability, and maintainability. It is divided into three primary layers:

### Data Layer
- **Repositories:** Implementations of domain repository interfaces. Handles data retrieval and storage.
- **Data Sources:** Interfaces and implementations for interacting with external sources (e.g., local file system).
- **Models:** Data transfer objects that map to external data formats.

### Domain Layer
- **Entities:** Core business objects (e.g., Book, Chapter, ePub Metadata).
- **Use Cases (Interactors):** Application-specific business rules. Each use case represents a single action the user can perform.
- **Repository Interfaces:** Abstract contracts for data operations, ensuring the domain layer remains independent of the data layer.

### Presentation Layer
- **UI (Widgets/Views):** UI components responsible for rendering the interface.
- **State Management:** Controllers and ViewModels that hold UI state and handle user interactions by calling appropriate use cases.

---

## 2. State Management
The project uses **Provider** or **Riverpod** for a lightweight, reactive state management solution.
- Used for dependency injection and exposing state to the UI.
- Manages complex state and asynchronous operations, keeping the UI decoupled from business logic.

---

## 3. Core Parsing Flow
The core functionality of reading an EPUB relies on the following parsing flow:

1. **File Picker:** 
   - The user selects an EPUB file via a file picker dialogue.
2. **Temp Unzip:**
   - The selected `.epub` file (which is a zipped archive) is extracted into a temporary directory on the device.
3. **Metadata Extraction:**
   - The app parses the `container.xml` and package documents (`.opf`) to extract metadata (Title, Author, Cover Image) and the reading order (spine/table of contents).
4. **WebView Render:**
   - The extracted XHTML/HTML content is loaded and rendered within a WebView widget. 
   - Communication between the app and the WebView handles pagination, custom styling, and navigation.
