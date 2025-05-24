
import 'dart:convert';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WishlistProvider with ChangeNotifier {
  List<WishlistItem > _wishlistItems = [];
  static const String _wishlistKey = 'wishlist_items';

  List<WishlistItem> get wishlistItems => _wishlistItems;

  int get wishlistCount => _wishlistItems.length;

  bool isInWishlist(int productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }

  // Initialize and load from local storage
  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? wishlistString = prefs.getString(_wishlistKey);
      
      if (wishlistString != null) {
        final List<dynamic> wishlistJson = json.decode(wishlistString);
        _wishlistItems = wishlistJson
            .map((item) => WishlistItem.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }

  // Save to local storage
  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String wishlistString = json.encode(
        _wishlistItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_wishlistKey, wishlistString);
    } catch (e) {
      debugPrint('Error saving wishlist: $e');
    }
  }

  // Add item to wishlist
  Future<void> addToWishlist({
    required int id,
    required String title,
    required double price,
    required String image,
    required String category,
  }) async {
    // Check if item already exists
    if (!isInWishlist(id)) {
      final newItem = WishlistItem(
        id: id,
        title: title,
        price: price,
        image: image,
        category: category,
      );
      
      _wishlistItems.add(newItem);
      await _saveWishlist();
      notifyListeners();
    }
  }

  // Remove item from wishlist
  Future<void> removeFromWishlist(int productId) async {
    _wishlistItems.removeWhere((item) => item.id == productId);
    await _saveWishlist();
    notifyListeners();
  }

  // Toggle wishlist status
  Future<void> toggleWishlist({
    required int id,
    required String title,
    required double price,
    required String image,
    required String category,
  }) async {
    if (isInWishlist(id)) {
      await removeFromWishlist(id);
    } else {
      await addToWishlist(
        id: id,
        title: title,
        price: price,
        image: image,
        category: category,
      );
    }
  }

  // Clear all wishlist items
  Future<void> clearWishlist() async {
    _wishlistItems.clear();
    await _saveWishlist();
    notifyListeners();
  }

  // Get wishlist item by ID
  WishlistItem? getWishlistItem(int productId) {
    try {
      return _wishlistItems.firstWhere((item) => item.id == productId);
    } catch (e) {
      return null;
    }
  }
}