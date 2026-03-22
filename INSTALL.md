# Installation & Setup

## Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (comes with Flutter)
- A connected device or emulator (iOS Simulator, Android Emulator, or Web Browser)

## Quick Start

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone <repository-url>
   cd epub-reader
   ```

2. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   ```bash
   flutter run
   ```

## Development Commands
- **Generate Code (if using Freezed/JsonSerializable):**
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- **Run Tests:**
  ```bash
  flutter test
  ```
