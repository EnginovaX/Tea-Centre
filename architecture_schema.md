# Tea Centre: Food Delivery Platform Architecture

## 1. System Overview
A production-grade food delivery platform for 'Tea Centre' specializing in Indian snacks. Built using Flutter for cross-platform mobile apps and Firebase for a scalable, serverless backend.

## 2. Technical Stack
- **Frontend:** Flutter (Dart)
- **Architecture:** Clean Architecture with MVVM
- **State Management:** Riverpod
- **Backend:** Firebase (Auth, Firestore, Storage, Cloud Functions)
- **Payments:** Razorpay API & COD
- **Mapping:** Google Maps Platform (Maps SDK, Places, Directions)

## 3. Firestore Database Schema

### `users` Collection
- `uid`: String (Primary Key)
- `name`: String
- `phone`: String
- `address`: Map { lat, lng, address_line }
- `created_at`: Timestamp

### `products` Collection
- `id`: String
- `name`: String (e.g., "Masala Chai", "Samosa")
- `category`: String ("Chai", "Snacks", "Combos")
- `price`: Double
- `image_url`: String
- `is_available`: Boolean

### `orders` Collection
- `id`: String
- `customer_id`: String (Reference to users)
- `items`: List<Map> [{ product_id, name, quantity, price }]
- `total_amount`: Double
- `payment_status`: String ("Pending", "Paid", "Failed")
- `payment_method`: String ("Razorpay", "COD")
- `order_status`: String ("Pending", "Preparing", "Out for Delivery", "Delivered")
- `delivery_location`: Map { lat, lng, address_line }
- `created_at`: Timestamp

## 4. Folder Structure (Clean Architecture)
```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/ (Firebase Remote DS)
├── domain/
│   ├── entities/
│   └── repositories/ (Interfaces)
├── presentation/
│   ├── providers/ (Riverpod State)
│   ├── screens/
│   └── widgets/
└── main.dart
```

## 5. Security Rules & Best Practices
- Firebase Security Rules to restrict `products` write access to Admin only.
- Razorpay API keys stored in `.env` (using flutter_dotenv).
- Use Firebase Cloud Functions for sensitive operations like payment verification and push notifications.