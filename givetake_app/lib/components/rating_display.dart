import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final double rate;
  final int count;
  final bool showCount;
  final double starSize;

  /* Constructer */
  const RatingDisplay({
    super.key,
    required this.rate,
    required this.count,
    this.showCount = true,
    this.starSize = 16,
  });

  /* Build Method */
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* Stars */
        ...List.generate(5, (index) {
          if (index < rate.floor()) {
            return Icon(
              Icons.star,
              color: Theme.of(context).primaryColor,
              size: starSize,
            );
          } else if (index < rate) {
            return Icon(
              Icons.star_half,
              color: Theme.of(context).primaryColor,
              size: starSize,
            );
          } else {
            return Icon(
              Icons.star_border,
              color: Theme.of(context).primaryColor,
              size: starSize,
            );
          }
        }),

        const SizedBox(width: 4),

        /* Rating Value */
        Text(
          rate.toStringAsFixed(1),
          style: TextStyle(
            fontSize: starSize * 0.8,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

        /* Count */
        if (showCount) ...[
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: starSize * 0.7,
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }
}
