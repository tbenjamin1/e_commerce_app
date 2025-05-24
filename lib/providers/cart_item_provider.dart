

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// models/cart_item.dart
class CartItem {
  final int productId;
  final String title;
  final double price;
  final String image;
  final String category;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    this.quantity = 1,
  });

  // Convert CartItem to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'category': category,
      'quantity': quantity,
    };
  }

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      title: json['title'],
      price: json['price'].toDouble(),
      image: json['image'],
      category: json['category'],
      quantity: json['quantity'],
    );
  }

  // Calculate total price for this item
  double get totalPrice => price * quantity;

  // Create a copy with updated quantity
  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      title: title,
      price: price,
      image: image,
      category: category,
      quantity: quantity ?? this.quantity,
    );
  }
}

// models/product.dart (if not already created)
class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'].toDouble(),
      count: json['count'],
    );
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }
}



class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  static const String _cartKey = 'cart_items';

  List<CartItem> get cartItems => _cartItems;

  // Get total number of items in cart
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total price of all items in cart
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Check if product is in cart
  bool isInCart(int productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  // Get quantity of specific product in cart
  int getQuantity(int productId) {
    final item = _cartItems.where((item) => item.productId == productId).firstOrNull;
    return item?.quantity ?? 0;
  }

  // Load cart from local storage
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      
      if (cartJson != null) {
        final List<dynamic> cartList = json.decode(cartJson);
        _cartItems = cartList.map((json) => CartItem.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  // Save cart to local storage
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(_cartItems.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  // Add product to cart - accepts any object with required properties
  Future<void> addToCart(dynamic product, {int quantity = 1}) async {
    final existingIndex = _cartItems.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      // Product already exists, update quantity
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      // Add new product to cart
      _cartItems.add(CartItem(
        productId: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
        category: product.category,
        quantity: quantity,
      ));
    }
    
    await _saveCart();
    notifyListeners();
  }

  // Remove product from cart completely
  Future<void> removeFromCart(int productId) async {
    _cartItems.removeWhere((item) => item.productId == productId);
    await _saveCart();
    notifyListeners();
  }

  // Update quantity of product in cart
  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      await _saveCart();
      notifyListeners();
    }
  }

  // Increase quantity by 1
  Future<void> increaseQuantity(int productId) async {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
      await _saveCart();
      notifyListeners();
    }
  }

  // Decrease quantity by 1
  Future<void> decreaseQuantity(int productId) async {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index] = _cartItems[index].copyWith(
          quantity: _cartItems[index].quantity - 1,
        );
        await _saveCart();
        notifyListeners();
      } else {
        await removeFromCart(productId);
      }
    }
  }

  // Clear all items from cart
  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
    notifyListeners();
  }

  // Get cart item by product ID
  CartItem? getCartItem(int productId) {
    try {
      return _cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }
}

// Extension for null safety
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}