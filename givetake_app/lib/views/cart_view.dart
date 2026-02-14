import 'package:flutter/material.dart';
import '../models/product_service.dart';
import '../components/cart_item_card.dart';
import '../components/empty_state.dart';

class CartView extends StatelessWidget {
  final List<ProductService> cartItems;
  final Function(ProductService) onRemove;

  /* Constructer */
  const CartView({super.key, required this.cartItems, required this.onRemove});

  /* Calculate Total */
  double _calculateTotal() {
    return cartItems.fold(0, (sum, item) => sum + (item.price ?? 0));
  }

  /* Build Method */
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          /* Header */
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sepetim',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (cartItems.isNotEmpty)
                  Text(
                    '${cartItems.length} ürün',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),

          /* Content */
          Expanded(
            child: cartItems.isEmpty
                ? const EmptyState(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Sepetiniz boş',
                    subtitle: 'Alışverişe başlamak için ürünleri inceleyin',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemCard(
                        product: cartItems[index],
                        onRemove: () => onRemove(cartItems[index]),
                      );
                    },
                  ),
          ),

          /* Total Price and Buy */
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Toplam',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        '\$${_calculateTotal().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Satın alma işlemi simüle edildi!',
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                      child: const Text('Satın Al'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
