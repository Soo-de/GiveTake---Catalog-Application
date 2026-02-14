import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_service.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // Fetch products from API
  static Future<List<ProductService>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      // convert response to list of products
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductService.fromJson(json)).toList();
    } else {
      throw Exception(
        'Ürünler yüklenirken hata oluştu: ${response.statusCode}',
      );
    }
  }

  // Get categories
  static List<String> getCategories(List<ProductService> products) {
    final categories = products.map((p) => p.category ?? '').toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  // Filter products by category
  static List<ProductService> filterByCategory(
    List<ProductService> products,
    String category,
  ) {
    if (category == 'All') return products;
    return products.where((p) => p.category == category).toList();
  }

  // Search products
  static List<ProductService> searchProducts(
    List<ProductService> products,
    String query,
  ) {
    if (query.isEmpty) return products;
    return products
        .where(
          (p) => (p.title ?? '').toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Sort products
  static List<ProductService> sortProducts(
    List<ProductService> products,
    String sortOption,
  ) {
    List<ProductService> sorted = List.from(products);
    switch (sortOption) {
      case 'price_low':
        sorted.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
      case 'price_high':
        sorted.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case 'rating':
        sorted.sort(
          (a, b) => (b.rating?.rate ?? 0).compareTo(a.rating?.rate ?? 0),
        );
        break;
      default:
        break;
    }
    return sorted;
  }
}
