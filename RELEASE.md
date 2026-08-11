# Saffron & Steam (Tea Centre) - Android Release Manual

Use this manual to prepare, sign, and build production-ready Android packages (APKs / App Bundles) for Google Play Store.

---

## 📦 App Release Details
- **Application Name:** Tea Centre
- **Application ID:** `com.teacentre`
- **Minimum SDK Support:** Android 21 (Lollipop)
- **Target SDK Support:** Android 34 (UpsideDownCake)

---

## 🔑 Generate Local Release Keystore

To sign your production application packages, you must generate a secure keystore file:

### 1. Run Keytool Utility
Execute the following command in your terminal to generate a secure `upload-keystore.jks` file:
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. Configure Local Credentials
Create a private file named `android/key.properties` (this file is excluded via `.gitignore` to prevent secret leaks) and define your keystore references:
```properties
storePassword=your_keystore_password_here
keyPassword=your_key_password_here
keyAlias=upload
storeFile=upload-keystore.jks
```

### 3. Edit Build Gradle
Ensure `android/app/build.gradle` is updated to utilize your `key.properties` variables for signing release configurations automatically:
```groovy
def keystorePropertiesSuite = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystorePropertiesSuite.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                storeFile file(keystorePropertiesSuite['storeFile'])
                storePassword keystorePropertiesSuite['storePassword']
                keyAlias keystorePropertiesSuite['keyAlias']
                keyPassword keystorePropertiesSuite['keyPassword']
            }
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

---

## 🏗️ Production Build Commands

Follow these steps to clean and compile production artifacts:

### 1. Clean Local Caches
Before compiling a release build, always purge old artifacts:
```bash
flutter clean
flutter pub get
```

### 2. Compile Debug APK (Verification Build)
To output an unsigned package for local QA testing:
```bash
flutter build apk --debug
```

### 3. Compile Release APK (Signed Build)
To compile a fully signed and optimized installation package:
```bash
flutter build apk --release
```

### 4. Compile Android App Bundle (AAB - Play Store Submission)
To generate the optimal publishing package for Google Play Store upload:
```bash
flutter build appbundle
```
The compiled bundle will be outputted to `build/app/outputs/bundle/release/app-release.aab`.
