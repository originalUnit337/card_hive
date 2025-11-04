# Card Hive

## Project Overview

Card Hive is a Flutter mobile application designed for managing loyalty cards. It allows users to store their card information, including barcodes, for easy access. The project follows a Clean Architecture pattern, separating concerns into `data`, `domain`, and `presentation` layers.

**Key Technologies:**

*   **Framework:** Flutter
*   **State Management:** `flutter_bloc`
*   **Dependency Injection:** `get_it`
*   **Navigation:** `go_router`
*   **Database:** `ObjectBox`
*   **Barcode Scanning:** `mobile_scanner`

## Building and Running

To build and run the project, use the following standard Flutter commands:

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

**Testing:**

To run the tests, use the following command:

```bash
flutter test
```

## Development Conventions

*   **Architecture:** The project follows Clean Architecture principles, with a clear separation of concerns between the data, domain, and presentation layers.
*   **State Management:** `flutter_bloc` is used for managing the application's state. Blocs are used to handle business logic and emit states that the UI can react to.
*   **Dependency Injection:** `get_it` is used for dependency injection, which helps to decouple the different parts of the application.
*   **Code Style:** The code follows the standard Dart and Flutter style guides. `flutter_lints` is used to enforce these styles.
