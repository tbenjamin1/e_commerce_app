import 'package:e_commerce_app/constants/colors.dart';
import 'package:e_commerce_app/providers/cart_item_provider.dart';
import 'package:e_commerce_app/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({
    required this.productId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer2<ProductProvider, CartProvider>(
        builder: (context, productProvider, cartProvider, child) {
          // Find the product by ID
          final product = productProvider.products
              .where((p) => p.id == productId)
              .firstOrNull;

          if (product == null) {
            return const Center(
              child: Text(
                'Product not found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          final isFavorite = productProvider.isFavorite(product.id);
          final isInCart = cartProvider.isInCart(product.id);
          final cartQuantity = cartProvider.getQuantity(product.id);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFFF8F8F8),
                elevation: 0,
                pinned: true,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () =>
                          productProvider.toggleFavorite(product.id),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              // Product content
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 500,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      color: Colors.black,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 64,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // column of  product details
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Title
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Category
                            Text(
                              product.category,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 2),

                            // Rating
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  product.rating.rate.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${product.rating.count} Reviews',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Description
                            if (product.description.isNotEmpty) ...[
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                product.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF666666),
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(
                                  height: 100), // Space for bottom section
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Bottom section with price and add to cart
      bottomNavigationBar: Consumer2<ProductProvider, CartProvider>(
        builder: (context, productProvider, cartProvider, child) {
          final product = productProvider.products
              .where((p) => p.id == productId)
              .firstOrNull;

          if (product == null) return const SizedBox.shrink();
          final isInCart = cartProvider.isInCart(product.id);
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: BoxDecoration(
              color: bottomprimaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Price section
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Add to cart button
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isInCart
                            ? () {
                                // cart_screen
                                context.go('/cart');
                              }
                            : () => _addToCart(context, cartProvider, product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInCart
                              ? const Color(0xFF4CAF50)
                              : primarybuttonColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isInCart ? 'View Cart' : 'Add to Cart',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _addToCart(
      BuildContext context, CartProvider cartProvider, product) async {
    await cartProvider.addToCart(product);
    _showAddToCartDialog(context, product.title);
  }

  void _showAddToCartDialog(BuildContext context, String productTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Added to Cart',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            '$productTitle has been added to your cart!',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to cart screen
                context.go('/cart');
              },
              style: TextButton.styleFrom(
                backgroundColor: primarybuttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'View Cart',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveFromCartDialog(BuildContext context,
      CartProvider cartProvider, int productId, String productTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Remove from Cart',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "$productTitle" from your cart?',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                cartProvider.removeFromCart(productId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$productTitle removed from cart'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Remove',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Extension to handle null safety for firstOrNull
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
