import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/providers/cart_item_provider.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final BuildContext context;
  final CartProvider cartProvider;
  final CartItem cartItem;

  const CartItemCard(this.context, this.cartProvider, this.cartItem, {super.key});

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
       
        child: Icon(
          icon,
          size: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: const Color(0xFFF8F8F8),
              child: Image.network(
                cartItem.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 32,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        cartItem.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Quantity
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onPressed: () => cartProvider.decreaseQuantity(cartItem.productId),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Colors.grey.shade400),
                                  right: BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${cartItem.quantity}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onPressed: () => cartProvider.increaseQuantity(cartItem.productId),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Center(
                  child: Text(
                    '\$${cartItem.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
