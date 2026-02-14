import 'package:flutter/material.dart';
import '../models/product_service.dart';
import '../components/rating_display.dart';

class ProductDetailView extends StatelessWidget {
  final ProductService product;
  final Function(ProductService) onAddToCart;

  /* Product Detail View Constructor */
  const ProductDetailView({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  /* Build Method */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ürün Detayı',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      /* Body Content */
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Product Image */
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Hero(
                tag: 'product_${product.id}',
                child: Image.network(
                  product.image ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported_outlined,
                      size: 80,
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.3),
                    );
                  },
                ),
              ),
            ),

            /* Product Information */
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Category */
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      product.category ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /* Title */
                  Text(
                    product.title ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /* Rating */
                  if (product.rating != null)
                    RatingDisplay(
                      rate: product.rating!.rate ?? 0,
                      count: product.rating!.count ?? 0,
                      starSize: 20,
                    ),

                  const SizedBox(height: 16),

                  /* Price */
                  Text(
                    '\$${product.price?.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /* Description Title */
                  Text(
                    'Açıklama',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /* Description */
                  Text(
                    product.description ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      /* Add to Cart Button */
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        
        child: ElevatedButton.icon(
          onPressed: () {
            onAddToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.title} sepete eklendi!'),
                backgroundColor: Theme.of(context).primaryColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text('Sepete Ekle'),
        ),
      ),
    );
  }
}
