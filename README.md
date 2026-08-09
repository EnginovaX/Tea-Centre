# Tea Centre (Saffron & Steam)

A production-ready cross-platform mobile application specializing in premium tea blends and Indian snacks. Built using Flutter (Dart), Clean Architecture, MVVM design, and Firebase.

---

## 🚀 Architectural Blueprint (Clean Architecture with MVVM)

The codebase is organized into four strictly decoupled horizontal layers:

```text
lib/
├── core/            # Global styling, themes, GoRouter configurations, localization, and utilities
├── domain/          # Plain Dart Business Rules: Pure Entities and Repository Contracts
├── data/            # Data Sources (Firebase, Local Hive Session) and Repository Implementations
└── presentation/    # Riverpod state management (MVVM) and responsive Material 3 Screens/Widgets
```

- **Domain Layer:** Pure business logic containing standard objects like `StoreSettingsEntity` and abstract interfaces.
- **Data Layer:** Interacts with Firebase services (Authentication, Firestore, Storage) and handles offline queues via Hive.
- **Presentation Layer:** Watches Riverpod state providers and draws responsive Material 3 UI screens that adapt gracefully from mobile to tablet viewports.

---

## 🔒 Environment Configurations & Variables

The app supports dynamic settings loaded securely. A `.env.example` template is provided in the repository root containing parameters for:
- **Firebase Platform:** Web, Android, and iOS SDK configurations.
- **Google Maps Key:** Android and iOS API integration keys.
- **Razorpay Keys:** Distinct configurations for `rzp_test` (simulation mode) and `rzp_live` (production mode).
- **Store Logistics:** Confined parameters such as:
  - `STORE_DELIVERY_RADIUS_KM` (Defaults to `10.0` km)
  - `STORE_DELIVERY_CHARGE` (Defaults to `30.0` INR)
  - `STORE_TAX_RATE` (Defaults to `5.0` representing 5% GST)

---

## 📋 Phase 5 Core System Implementations

### 1. Store Settings Management
- **Operatability:** Includes `isStoreOpen`, `openingTime`, `closingTime`, `deliveryRadiusKm`, `minOrderAmount`, `deliveryCharge`, and `taxRate` fields.
- **Synchronization:** The `storeSettingsProvider` coordinates and distributes the live settings to both the Customer and Admin app views seamlessly.

### 2. Geographical Location & Delivery Checks
- **Haversine Distance Model:** Incorporates custom `MapsService` with geographical calculation formulas.
- **Radius Bounds Validation:** Automatically calculates user distance from the central store (located at Churchgate Mumbai). If distance > 10 km, home delivery is elegantly disabled with clear visual error messaging, prompting the customer to select "Self Pickup" instead.

### 3. Shopping Cart and Calculations
- **Precise Totals:** Calculates `Subtotal` from item quantities, adds flat `Delivery Charge` (if delivery is chosen), calculates `5% GST` on the subtotal, and computes the correct `Grand Total`.
- **Constraint Handling:** Automatically blocks empty cart checkout and handles item stock increments / decrements correctly in real-time.

### 4. Razorpay Secure Payment Flow
- **Verification Integrity:** Simulates distinct checkout flows for payments (Success, Fail, and Cancel) using secure signature comparisons. Invalid SHA256 HMAC signatures are strictly blocked to prevent client-side payment spoofing.

### 5. FCM Push Notifications System
- **Real-time streams:** Uses a broadcast stream architecture to capture and log foreground/background notification events, including topic subscriptions and order fulfillment update triggers.

### 6. Local Offline Retry Protector
- **Queueing Safety:** Automatically saves failed orders or checkouts to Hive storage if the device is offline.
- **Background Dispatcher:** Detects network restoration, auto-retries queued orders, and prevents duplicates to ensure zero silent data loss.

### 7. Administrative Control Suite
- **Interactive Tools:** Includes product addition forms, low stock alert banners (alerts if stock <= threshold), promo coupon generators with custom percentage rules, and customer spend databases.

### 8. Production Security Rules
- **Firestore Rules:** Secure JSON policies to restrict products write access to validated Admin roles and isolate customer address books safely.
