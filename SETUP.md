# Saffron & Steam (Tea Centre) - Comprehensive Setup Guide

Follow this sequential setup manual to initialize and run the Tea Centre application successfully from scratch.

---

## 🛠️ Flutter Development Setup

### 1. Prerequisites
- **Flutter SDK:** Version `3.22.x` or later (compatible with Dart `>=3.4.0 <4.0.0`).
- **Java Development Kit (JDK):** Version `17` (required for modern Gradle builds).
- **Android Studio / Xcode:** For emulator setup and platform compilation tools.

### 2. Initialization
Clone the repository and fetch project dependencies:
```bash
flutter pub get
```

### 3. Verify Code Quality & Compilation
Run the standard static analysis tools to verify a clean codebase:
```bash
flutter analyze
```

---

## 🔥 Firebase Serverless Integration

The application integrates with Firebase Services (Auth, Firestore, Messaging, Storage, Analytics, and Crashlytics).

### 1. Create a Firebase Project
1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project named `tea-centre`.
2. Enable the following services in your console:
   - **Authentication:** Enable `Phone` sign-in and `Google` provider options.
   - **Cloud Firestore:** Initialize a database in "Production Mode".
   - **Cloud Storage:** Initialize default storage rules.

### 2. Configure Platforms
Use the [FlutterFire CLI](https://firebase.google.com/docs/cli) to automatically bind and register your platforms:
```bash
flutterfire configure
```
This tool generates `lib/firebase_options.dart` which registers your API keys and configuration parameters automatically.

---

## 🗺️ Google Maps SDK Configuration

The application uses Google Maps to validate delivery addresses and coordinates.

### 1. Generate Google Maps API Key
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a project, enable the **Maps SDK for Android** and **Maps SDK for iOS**.
3. Under **APIs & Services > Credentials**, generate an API key.

### 2. Android Configuration
Add the generated key to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="your_google_maps_android_api_key_here"/>
```

### 3. iOS Configuration
In `ios/Runner/AppDelegate.swift`, initialize the Maps SDK:
```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("your_google_maps_ios_api_key_here")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

## 💳 Razorpay Gateway Configuration

The app integrates with Razorpay for secure checkout flows.

### 1. Test Mode Setup
1. Create a developer account at [Razorpay Dashboard](https://dashboard.razorpay.com/).
2. Under **Settings > API Keys**, generate your `rzp_test` Key ID and Secret.
3. Save these credentials securely in your local `.env` file.

### 2. Production Transition
Once ready for release, request "Live Mode" on the dashboard, generate `rzp_live` credentials, and update your environment variables.

---

## 🔔 FCM Push Notifications

1. Download the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from your Firebase Console.
2. Place them in their respective platform folders (`android/app/` and `ios/Runner/`).
3. Deploy Firebase Cloud Functions to listen to the `orders/` Firestore collection and dispatch FCM push payloads automatically when an order's status changes.
