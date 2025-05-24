import 'package:e_commerce_app/providers/cart_item_provider.dart';
import 'package:flutter/material.dart';

class CheckoutSection extends StatelessWidget {
  final CartProvider cartProvider;
  final void Function(BuildContext context, CartProvider cartProvider)
      onCheckoutPressed;

  const CheckoutSection({
    super.key,
    required this.cartProvider,
    required this.onCheckoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Cart total section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Cart total',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 24),

            // Checkout Button
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () => onCheckoutPressed(context, cartProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
