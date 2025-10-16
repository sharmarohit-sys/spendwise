# 💸 SpendWise

A personal expense tracking app built with **Flutter**, following **Clean Architecture** and **Riverpod** for state management.

---

## 🧠 Architecture

SpendWise uses **Clean Architecture** principles with a **feature-first** structure.

```
lib/
├── core/              # Shared app-wide modules
│   ├── constants/     # App constants (dimensions, strings, images)
│   ├── di/            # Dependency injection setup using GetIt
│   ├── network/       # Network clients and configurations
│   ├── services/      # Firestore, Firebase, etc.
│   ├── theme/         # Colors, typography, app theme
│   ├── utils/         # Helpers and extensions
│   └── widgets/       # Shared UI components
│
├── features/          # Each feature follows Clean Architecture layers
│   ├── authentication/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── add_expense/
│   ├── home/
│   ├── invalid_expense/
│   ├── splash/
│   └── date_wise_expense/
│
├── firebase_options.dart
└── main.dart
```

---

## ⚙️ Tech Stack

* **Flutter 3.8.0+**
* **Dart 3**
* **Firebase Authentication**
* **Cloud Firestore**
* **Riverpod 3.0.2** for state management
* **GetIt** for dependency injection
* **Shared Preferences** for local storage
* **Internet Connection Checker** for connectivity
* **fl_chart** for analytics visualization

---

## 🚀 Features

* User authentication with Firebase
* Add, view, and categorize expenses
* Daily and weekly expense insights
* Offline support and auto-sync
* Analytics via charts

---

## 🧰 Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/spendwise.git
   ```

2. Navigate to the project:

   ```bash
   cd spendwise
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Setup Firebase:

   * Add your `google-services.json` and `GoogleService-Info.plist`
   * Ensure `firebase_options.dart` is generated via:

     ```bash
     flutterfire configure
     ```

5. Run the app:

   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run all unit and widget tests:

```bash
flutter test
```

---

## 🧑‍💻 Author

**SpendWise** is developed by [Your Name]
📧 [your.email@example.com](mailto:your.email@example.com)

---

## 🪪 License

This project is licensed under the **MIT License**.
