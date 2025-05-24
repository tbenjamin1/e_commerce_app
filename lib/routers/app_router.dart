import 'package:e_commerce_app/auth_screens/LoginScreen.dart';
import 'package:e_commerce_app/home_screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_commerce_app/auth_screens/splash_screen.dart';
import 'package:e_commerce_app/home_screens/ProductListingScreen.dart';
import 'package:e_commerce_app/home_screens/cart_screen.dart';
import 'package:e_commerce_app/home_screens/whish_list_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash Screen Route
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Login Screen Route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),

      // Home/Product Listing Route
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          final currentUser = state.uri.queryParameters['currentUser'] ?? '';
          return ProductListingScreen(currentUser: currentUser);
        },
      ),

      // Product Details Route
      GoRoute(
        path: '/product/:id',
        name: 'productDetails',
        builder: (context, state) {
          final productIdStr = state.pathParameters['id'];
          final productId = int.tryParse(productIdStr ?? '') ?? 0;
          return ProductDetailsScreen(productId: productId);
        },
      ),

      // Wishlist Route
      GoRoute(
        path: '/wishlist',
        name: 'wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),

      // Cart Route
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );

  static GoRouter get router => _router;
}
