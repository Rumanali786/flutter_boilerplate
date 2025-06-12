
# 🚀 Flutter Boilerplate

A reusable and scalable Flutter boilerplate using **GetX** for state management and routing. This template is designed to help you kickstart app development with a solid structure, pre-configured packages, and Firebase integration support.

---

## 📁 Folder Structure

```
  ├── lib/
        └── bootstrap.dart
        └── main.dart
        ├── utils/
            ├── constants/
            ├── extensions/
            ├── cache_client/
            ├── generated_assets/
            ├── theme/
            ├── helpers/
            ├── widgets/
        ├── domain/
            ├── auth_repository/
                └── auth_repository.dart
                └── repository.dart
                ├── config/
                    └── auth_endpoints.dart
                    └── config.dart
                ├── models/
                    └── user_model.dart
                ├── dtos/
                    └── register_dto.dart
                    └── dtos.dart
                    └── sign_in_dto.dart
                    └── change_password_dto.dart
        ├── presentation/
            ├── app/
                ├── controller/
                    └── app_controller.dart
                ├── view/
                    └── app_view.dart
                ├── services/
                    └── internet_checker_service.dart
                    └── cloud_messaging_service.dart
                    └── app_update_service.dart
```

---

## 🧰 Pre-Installed Packages

- `get`: State management, routing, dependency injection
- `http`: HTTP client
- `firebase_core`, `firebase_auth`, `cloud_firestore` (setup instructions below)

---

## 🛠️ Getting Started

### 1. Clone This Boilerplate

```bash
git clone https://github.com/Rumanali786/flutter_boilerplate.git new_project
cd new_project
rm -rf .git
git init
```

### 2. Rename Your Project

Update the project name in:

- `pubspec.yaml`
- Android → `android/app/build.gradle`
- iOS → `ios/Runner.xcodeproj/project.pbxproj`
- Package imports (`com.yourorg.new_project`)

Use VS Code’s global rename or [rename package](https://pub.dev/packages/rename).

---

## 🔥 Firebase Configuration

> Follow these steps to connect your project to Firebase:

### ✅ Step 1: Set Up Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project**, follow the prompts

### ✅ Step 2: Add Android App

- Register with your package name (e.g., `com.example.new_project`)
- Download the `google-services.json` file and place it in:

```
android/app/google-services.json
```

### ✅ Step 3: Add iOS App (Optional)

- Register iOS app with your iOS bundle ID
- Download `GoogleService-Info.plist` and place it in:

```
ios/Runner/GoogleService-Info.plist
```

### ✅ Step 4: Add Firebase Packages

Add these to your `pubspec.yaml`:

```yaml
  firebase_core: ^3.12.0
  firebase_messaging: ^15.2.3
  firebase_analytics: ^11.4.3
  firebase_remote_config: ^5.4.1
```

Run:

```bash
flutter pub get
```

### ✅ Step 5: Initialize Firebase

Edit `boostrap.dart`:

```dart
Future<void> bootstrap(FutureOr<Widget> Function() builder) async  { 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 }
```

---

## 🧪 Ready to Build

Use this command to run the app:

```bash
flutter run
```

---

## 🤝 Contribution

Feel free to fork, improve, or suggest changes. This template is meant to evolve with best practices.

---

## 👤 Author

**Ruman ali**  
📧 jutts1055@gmail.com.com  


## Sdk
```bash
dart: ">=3.6.0 <4.0.0"
flutter: ">=3.27.0"
```

[//]: # (🌐 [yourwebsite.com]&#40;https://yourwebsite.com&#41;)
