# E-Commerce Flutter App

A comprehensive e-commerce application built with Flutter, featuring user authentication, product browsing, shopping cart, order management, and user profile settings. The app is Firebase-ready and uses Provider for state management.

## 🚀 Features

### ✅ Completed Features
- **User Authentication**
  - Email/Password sign up and sign in
  - Google Sign-In integration (Firebase-ready)
  - Guest user mode
  - Password reset functionality
  - Profile management

- **Product Management**
  - Product browsing with categories
  - Search functionality
  - Product cards with images, ratings, and prices
  - Category filtering

- **Shopping Cart**
  - Add/remove products to/from cart
  - Quantity management
  - Real-time cart count badge
  - Cart persistence
  - Total calculation

- **Order Management**
  - Order creation from cart
  - Order status tracking (Pending, Confirmed, Shipped, Delivered, Cancelled)
  - Order history with detailed view
  - Order cancellation for pending orders
  - Tracking number support

- **User Profile & Settings**
  - Profile editing
  - Address management
  - Password change
  - Notification settings
  - Theme preferences
  - Help & support
  - Sign out functionality

- **Navigation**
  - Bottom navigation with 5 tabs
  - Cart badge with real-time updates
  - Smooth page transitions

## 🛠️ Technical Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Navigation**: Persistent Bottom Nav Bar
- **UI**: Material Design with custom gradients

## 📱 Screenshots

The app includes:
- Authentication screens (Sign In/Sign Up)
- Home page with product categories
- Browse page with search functionality
- Cart page with item management
- Orders page with status tracking
- Settings page with profile management

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### 1. Clone the Repository
```bash
git clone <repository-url>
cd e_commerce
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Add your app (Android/iOS/Web)

#### Configure Firebase
1. **Android Setup**:
   - Download `google-services.json`
   - Place it in `android/app/`
   - Update `android/app/build.gradle` with Firebase plugin

2. **iOS Setup**:
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`
   - Update `ios/Runner/Info.plist`

3. **Web Setup**:
   - Copy Firebase config to `lib/firebase_options.dart`
   - Update the configuration values

#### Enable Firebase Services
1. **Authentication**:
   - Go to Authentication > Sign-in method
   - Enable Email/Password
   - Enable Google Sign-In
   - Configure OAuth consent screen

2. **Firestore Database**:
   - Create Firestore database
   - Set up security rules (see `lib/firebase_config.dart`)

3. **Storage**:
   - Enable Cloud Storage
   - Set up storage rules

### 4. Update Configuration
Update `lib/firebase_options.dart` with your Firebase project configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-web-api-key',
  appId: 'your-web-app-id',
  messagingSenderId: 'your-messaging-sender-id',
  projectId: 'your-project-id',
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
);
```

### 5. Run the App
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── constants/
│   └── Colors.dart              # App color scheme
├── custom_widgets/
│   ├── Product_Card.dart        # Product display widget
│   ├── category_card.dart       # Category display widget
│   └── InputField.dart          # Custom input field
├── models/
│   └── Products_model.dart      # Product data model
├── pages/
│   ├── Home/
│   │   └── home_page.dart      # Home screen
│   ├── Browse/
│   │   └── browse_page.dart    # Browse/search screen
│   ├── Cart/
│   │   └── cart_page.dart      # Shopping cart screen
│   ├── Orders/
│   │   └── Orders.dart         # Orders management screen
│   ├── Seettings/
│   │   └── settings_page.dart  # Settings/profile screen
│   ├── SignIn_page.dart        # Sign in screen
│   ├── SignUp_page.dart        # Sign up screen
│   └── Main_Page.dart          # Main navigation wrapper
├── providers/
│   ├── auth_provider.dart      # Authentication state management
│   ├── cart-provider.dart      # Cart state management
│   ├── product-provider.dart   # Product state management
│   ├── orders_provider.dart    # Orders state management
│   └── address_provider.dart   # Address state management
├── firebase_options.dart       # Firebase configuration
├── firebase_config.dart        # Firebase setup instructions
└── main.dart                   # App entry point
```

## 🔐 Security Rules

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    match /addresses/{addressId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/profile/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

## 🗄️ Database Schema

### Collections Structure

#### Users Collection
```javascript
users/{userId} {
  id: string,
  email: string,
  name: string,
  phoneNumber: string (optional),
  profileImageUrl: string (optional),
  createdAt: timestamp,
  updatedAt: timestamp
}
```

#### Orders Collection
```javascript
orders/{orderId} {
  id: string,
  userId: string,
  items: array,
  totalAmount: number,
  status: string,
  paymentMethod: string,
  shippingAddress: string (optional),
  createdAt: timestamp,
  updatedAt: timestamp (optional),
  trackingNumber: string (optional)
}
```

#### Addresses Collection
```javascript
addresses/{addressId} {
  id: string,
  userId: string,
  fullName: string,
  phoneNumber: string,
  addressLine1: string,
  addressLine2: string (optional),
  city: string,
  state: string,
  postalCode: string,
  country: string,
  isDefault: boolean,
  createdAt: timestamp
}
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔄 State Management

The app uses Provider for state management with the following providers:

- **AuthProvider**: Manages user authentication state
- **CartProvider**: Manages shopping cart state
- **ProductProvider**: Manages product data and filtering
- **OrdersProvider**: Manages order history and status
- **AddressProvider**: Manages user addresses

## 🎨 UI/UX Features

- **Responsive Design**: Works on all screen sizes
- **Custom Gradients**: Beautiful color schemes
- **Smooth Animations**: Bouncing scroll physics
- **Error Handling**: Comprehensive error management
- **Loading States**: User-friendly loading indicators
- **Empty States**: Informative empty state messages

## 🔧 Customization

### Colors
Update `lib/constants/Colors.dart` to customize the app's color scheme.

### Products
Add products by updating JSON files in `assets/JSONS/` directory.

### Categories
Modify category lists in home and browse pages.

## 📝 TODO

- [ ] Implement payment integration
- [ ] Add push notifications
- [ ] Implement product reviews and ratings
- [ ] Add wishlist functionality
- [ ] Implement admin panel
- [ ] Add product variants (size, color)
- [ ] Implement coupon system
- [ ] Add order tracking with maps integration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Developer

**Miftah Fentaw**
- Email: miftah@example.com
- GitHub: [@miftahfentaw](https://github.com/miftahfentaw)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for backend services
- Provider package for state management
- Material Design for UI components

---

**Note**: This app is Firebase-ready. Make sure to configure Firebase properly before running in production. The current implementation includes mock data for demonstration purposes.