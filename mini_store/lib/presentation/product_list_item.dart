import 'package:flutter/material.dart';
import '../domain/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductListItem({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Image.network(
          product.image,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(' 24${product.price.toStringAsFixed(2)}'),
        onTap: onTap,
      ),
    );
  }
} 