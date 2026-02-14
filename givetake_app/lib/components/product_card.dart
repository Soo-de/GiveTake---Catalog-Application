import 'package:flutter/material.dart';
import '../models/product_service.dart';
import 'rating_display.dart';

class ProductCard extends StatelessWidget {
  final ProductService product;
  final VoidCallback onTap;

  /* Constructer */
  const ProductCard({super.key, required this.product, required this.onTap});

  /* Build Method */
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Product Image */
              Expanded(
                flex: 3,
                child: Center(
                  child: Hero(
                    tag: 'product_${product.id}',
                    child: Image.network(
                      product.image ?? '',
                      fit: BoxFit.contain,
                      cacheWidth: 200,
                      gaplessPlayback: true,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.3),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /* Product Title */
              Expanded(
                flex: 1,
                child: Text(
                  product.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              /* Rating */
              if (product.rating != null)
                RatingDisplay(
                  rate: product.rating!.rate ?? 0,
                  count: product.rating!.count ?? 0,
                  showCount: false,
                  starSize: 14,
                ),

              const SizedBox(height: 4),

              /* Price */
              Text(
                '\$${product.price?.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
