# Flutter E-Commerce App (FakeStore)

A Flutter-based e-commerce application that integrates with the FakeStore API to provide a complete shopping experience with product browsing, cart management, and wishlist functionality.

## 📱 Features

### Core Features
- **User Authentication**: Login with FakeStore API credentials
- **Product Catalog**: Browse products with lazy loading
- **Product Details**: View detailed product information
- **Shopping Cart**: Add/remove products with real-time total calculation
- **Wishlist**: Save favorite products locally (Optional feature implemented)

### Technical Features
- Clean Architecture with Provider pattern
- State Management using Provider
- HTTP API integration with FakeStore API
- Local storage for wishlist persistence
- Responsive UI following Figma design specifications
- Form validation and error handling

## 🏗️ Architecture

The app follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── main.dart                 # App entry point with Provider setup
├── routers/
│   └── app_router.dart      # Navigation routing configuration
├── providers/               # State management
│   ├── product_provider.dart
│   ├── cart_item_provider.dart
│   └── wishlist_provider.dart
├── home_screens/                 # UI screens
├── models/                  # Data models
├── constants/               # API services and colors
└── widgets/                # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd e_commerce_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1          
  http: ^1.1.0              
  shared_preferences: ^2.2.2 
  go_router: ^12.1.3        
  cached_network_image: ^3.3.0 
  flutter_launcher_icons: ^0.14.3 
```

## 🔧 Configuration

### API Configuration
The app uses the FakeStore API:
- **Base URL**: `https://fakestoreapi.com`
- **Products Endpoint**: `GET /products`
- **Login Endpoint**: `POST /auth/login`

### Test Credentials
```json
{
  "username": "johnd",
  "password": "m38rmF$"
}
```

## 📱 Screens & Functionality

### 1. Login Screen
- **Endpoint**: `POST https://fakestoreapi.com/auth/login`
- **Features**:
  - Form validation for email/username and password
  - Show/hide password functionality
  - Error handling for invalid credentials
  - Loading state during authentication

### 2. Product Listing Screen
- **Endpoint**: `GET https://fakestoreapi.com/products`
- **Features**:
  - Grid/List view of products
  - Product image, name, price, and rating display
  - Lazy loading for performance optimization
  - Pull-to-refresh functionality
  - Search and filter capabilities

### 3. Product Details Screen
- **Features**:
  - Full product description
  - Category and rating information
  - Add to cart functionality
  - Add to wishlist option
  - Image gallery/carousel
  - Quantity selector

### 4. Shopping Cart
- **Features**:
  - Add/remove products
  - Quantity adjustment
  - Real-time total calculation
  - Persistent cart state
  - Checkout preparation

### 5. Wishlist (Optional - Implemented)
- **Features**:
  - Add/remove products from wishlist
  - Local storage using SharedPreferences
  - Wishlist persistence across app sessions
  - Quick add to cart from wishlist

## 🎨 UI/UX Design

The app follows the provided Figma design specifications:
- **Design Reference**: [Figma Link](https://www.figma.com/design/3aiy97FCil69hNohf8w9AU/Fake-Store-LYQX?node-id=0-1&t=WvnbxMQ31PCMfhet-1)


## 🔄 State Management

The app uses Provider pattern for state management:

### ProductProvider
- Manages product data fetching
- Handles loading states and error handling
- Implements lazy loading for performance

### CartProvider
- Manages cart items and quantities
- Calculates total prices
- Persists cart state during app lifecycle

### WishlistProvider
- Manages wishlist items
- Handles local storage operations
- Synchronizes with SharedPreferences

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```


## 📊 Performance Optimizations

- **Image Caching**: Using cached_network_image for efficient image loading
- **Lazy Loading**: Products loaded in batches to reduce initial load time
- **State Optimization**: Efficient state updates to minimize rebuilds
- **Memory Management**: Proper disposal of controllers and listeners

## 🔒 Security & Error Handling

- Input validation on login frm

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```


## ⏱️ Development Timeline

**Estimated Development Time: 16-20 hours**

- **Day 1 (6-8 hours)**:
  - Project setup and architecture planning
  - API integration and models
  - Login screen implementation

- **Day 2 (6-8 hours)**:
  - Product listing with lazy loading
  - Product details screen
  - Cart functionality implementation

- **Day 3 (4 hours)**:
  - Wishlist implementation
  - UI polish and testing
  - Documentation and deployment preparation



## Contact

**Developer**: [tbenjamin1]
- **Email**: [tbenpollyl@gmail.com]
- **GitHub**: [https://github.com/tbenjamin1]

