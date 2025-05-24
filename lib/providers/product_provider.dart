import 'package:e_commerce_app/constants/api_urls.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



// Product Provider for state management
class ProductProvider extends ChangeNotifier {
  List<Product > _products = [];
  Set<int> _favoriteProducts = {};
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _itemsPerPage = 6;
  String? _errorMessage;

  // Getters
  List<Product> get products => _products;
  Set<int> get favoriteProducts => _favoriteProducts;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  String? get errorMessage => _errorMessage;
  
  List<Product> get favoriteProductsList => 
      _products.where((product) => _favoriteProducts.contains(product.id)).toList();

  // Load initial products
  Future<void> loadProducts() async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Product> allProducts =
            jsonData.map((json) => Product.fromJson(json)).toList();

        _products = allProducts.take(_itemsPerPage).toList();
        _currentPage = 1;
        _hasMore = allProducts.length > _itemsPerPage;
        _setLoading(false);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      _setError('Error loading products: $e');
      _setLoading(false);
    }
  }

  // Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;

    _setLoading(true);

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Product> allProducts =
            jsonData.map((json) => Product.fromJson(json)).toList();

        final int startIndex = _currentPage * _itemsPerPage;
        final int endIndex = (_currentPage + 1) * _itemsPerPage;

        if (startIndex < allProducts.length) {
          final List<Product> newProducts =
              allProducts.skip(startIndex).take(_itemsPerPage).toList();

          _products.addAll(newProducts);
          _currentPage++;
          _hasMore = endIndex < allProducts.length;
        } else {
          _hasMore = false;
        }
        _setLoading(false);
      }
    } catch (e) {
      _setError('Error loading more products: $e');
      _setLoading(false);
    }
  }

  // Toggle favorite status
  void toggleFavorite(int productId) {
    if (_favoriteProducts.contains(productId)) {
      _favoriteProducts.remove(productId);
    } else {
      _favoriteProducts.add(productId);
    }
    notifyListeners();
  }

  // Check if product is favorite
  bool isFavorite(int productId) {
    return _favoriteProducts.contains(productId);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset provider state
  void reset() {
    _products.clear();
    _favoriteProducts.clear();
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}