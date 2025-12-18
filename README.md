# Flutter Mobile App Wrapper

This is a high-performance native app wrapper for your landing page.

## How to build your app

### 1. Requirements
* Install **Flutter SDK** from [flutter.dev](https://flutter.dev)
* Install **Android Studio** (for Android apps)
* Install **Xcode** (for iOS apps - requires a Mac)

### 2. Setup
Replace the URL in `lib/main.dart` with your live website domain:
```dart
..loadRequest(Uri.parse('https://your-domain.com'));
```

### 3. Build the App
Open your terminal in this folder and run:

**For Android:**
```bash
flutter build apk --release
```
The file will be at `build/app/outputs/flutter-apk/app-release.apk`.

**For iOS:**
```bash
flutter build ios --release
```

## Features
* **Premium Loading**: Custom animation while the page loads.
* **Smart Back Button**: Android back button works like a browser.
* **External Links**: Automatically handles WhatsApp, Phone calls, and Emails.
* **Offline UI**: Clean error page if the user has no internet.
