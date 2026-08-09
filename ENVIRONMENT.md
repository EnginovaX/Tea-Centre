# Saffron & Steam (Tea Centre) - Environment Parameters Index

This document outlines the purpose, fallback values, and security classifications for every parameter represented in the environment configuration.

---

## 📋 Parameter Matrix

| Parameter Name | Data Type | Default/Fallback Value | Classification | Description |
| :--- | :--- | :--- | :--- | :--- |
| **`FIREBASE_API_KEY`** | String | `none` | **SECRET** | Core API lookup key used to authenticate Web & iOS SDK calls to Firebase servers. |
| **`FIREBASE_PROJECT_ID`** | String | `none` | Public | Unique project identifier used to identify the target cloud backend instance. |
| **`GOOGLE_MAPS_API_KEY_ANDROID`** | String | `none` | **SECRET** | API key used to authenticate, bill, and render Google Maps SDK widgets on Android devices. |
| **`GOOGLE_MAPS_API_KEY_IOS`** | String | `none` | **SECRET** | API key used to authenticate, bill, and render Google Maps SDK widgets on iOS devices. |
| **`RAZORPAY_KEY_ID_TEST`** | String | `none` | Public | Public key ID used to initiate payment sheets in simulation/test checkout environments. |
| **`RAZORPAY_KEY_SECRET_TEST`** | String | `none` | **SECRET** | Private API secret used to securely verify simulated payment signatures on the backend. |
| **`RAZORPAY_KEY_ID_LIVE`** | String | `none` | Public | Public key ID used to process real customer checkouts in live production environments. |
| **`RAZORPAY_KEY_SECRET_LIVE`** | String | `none` | **SECRET** | Private API secret used to securely verify real customer payment signatures on the backend. |
| **`FCM_VAPID_KEY`** | String | `none` | Public | Voluntary Application Server Key used to initiate push endpoints on web browsers. |
| **`STORE_PHONE_NUMBER`** | String | `+912222043751` | Public | Confined contact phone number displayed in customer inquiry and support views. |
| **`STORE_WHATSAPP_NUMBER`** | String | `+919876543210` | Public | Recipient number for generating pre-filled customer support messages. |
| **`STORE_ADDRESS`** | String | `Churchgate, Mumbai` | Public | Geographical coordinate baseline used for calculating home delivery distances. |
| **`STORE_DELIVERY_RADIUS_KM`** | Double | `10.0` | Public | Confined maximum radius (in kilometers) within which home delivery is offered. |
| **`STORE_DELIVERY_CHARGE`** | Double | `30.0` | Public | Flat delivery fee added automatically to checkouts selecting "Home Delivery". |
| **`STORE_TAX_RATE`** | Double | `5.0` | Public | General GST percentage added to the subtotal of any customer cart during checkout. |

---

## 🔒 Security Best Practices
- **Do NOT commit `.env` files** containing real, live, or test credentials to the repository. The `.gitignore` file contains rules to block `.env` from accidental commits.
- Ensure all live API secrets are strictly restricted inside their cloud consoles (e.g. restricting Google Maps API key to your specific Android Application package signature and bundle ID).
