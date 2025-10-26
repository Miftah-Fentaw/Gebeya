// Firebase configuration file
// This file contains placeholder configuration for Firebase
// Replace with your actual Firebase project configuration

// For Firebase Web configuration
// const firebaseConfig = {
//   apiKey: "your-api-key-here",
//   authDomain: "your-project.firebaseapp.com",
//   projectId: "your-project-id",
//   storageBucket: "your-project.appspot.com",
//   messagingSenderId: "123456789",
//   appId: "your-app-id"
// };

// Instructions for Firebase setup:
// 1. Go to https://console.firebase.google.com/
// 2. Create a new project or select existing project
// 3. Add your app (Android/iOS/Web)
// 4. Download configuration files:
//    - For Android: google-services.json (place in android/app/)
//    - For iOS: GoogleService-Info.plist (place in ios/Runner/)
//    - For Web: Copy config object to lib/firebase_options.dart
// 5. Enable Authentication, Firestore, and Storage in Firebase Console
// 6. Configure Authentication providers (Email/Password, Google Sign-In)
// 7. Set up Firestore security rules
// 8. Configure Storage rules

// Firebase Security Rules Examples:

// Firestore Rules:
// rules_version = '2';
// service cloud.firestore {
//   match /databases/{database}/documents {
//     // Users can read/write their own user document
//     match /users/{userId} {
//       allow read, write: if request.auth != null && request.auth.uid == userId;
//     }
//     
//     // Users can read/write their own orders
//     match /orders/{orderId} {
//       allow read, write: if request.auth != null && 
//         resource.data.userId == request.auth.uid;
//     }
//     
//     // Users can read/write their own addresses
//     match /addresses/{addressId} {
//       allow read, write: if request.auth != null && 
//         resource.data.userId == request.auth.uid;
//     }
//     
//     // Products are readable by all authenticated users
//     match /products/{productId} {
//       allow read: if request.auth != null;
//       allow write: if false; // Only admins can write products
//     }
//   }
// }

// Storage Rules:
// rules_version = '2';
// service firebase.storage {
//   match /b/{bucket}/o {
//     // Users can upload their own profile images
//     match /users/{userId}/profile/{allPaths=**} {
//       allow read, write: if request.auth != null && request.auth.uid == userId;
//     }
//     
//     // Product images are readable by all
//     match /products/{allPaths=**} {
//       allow read: if true;
//       allow write: if false; // Only admins can upload product images
//     }
//   }
// }

// Authentication Setup:
// 1. Go to Authentication > Sign-in method
// 2. Enable Email/Password provider
// 3. Enable Google Sign-In provider
// 4. Configure OAuth consent screen
// 5. Add authorized domains for web

// Firestore Collections Structure:
// users/{userId}
//   - id: string
//   - email: string
//   - name: string
//   - phoneNumber: string (optional)
//   - profileImageUrl: string (optional)
//   - createdAt: timestamp
//   - updatedAt: timestamp

// orders/{orderId}
//   - id: string
//   - userId: string
//   - items: array of order items
//   - totalAmount: number
//   - status: string (pending, confirmed, shipped, delivered, cancelled)
//   - paymentMethod: string
//   - shippingAddress: string (optional)
//   - createdAt: timestamp
//   - updatedAt: timestamp (optional)
//   - trackingNumber: string (optional)

// addresses/{addressId}
//   - id: string
//   - userId: string
//   - fullName: string
//   - phoneNumber: string
//   - addressLine1: string
//   - addressLine2: string (optional)
//   - city: string
//   - state: string
//   - postalCode: string
//   - country: string
//   - isDefault: boolean
//   - createdAt: timestamp

// products/{productId}
//   - id: number
//   - name: string
//   - description: string
//   - price: number
//   - category: string
//   - image: string
//   - stock: number
//   - rating: number
//   - createdAt: timestamp
//   - updatedAt: timestamp
