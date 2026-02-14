import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'models/product_service.dart';
import 'views/home_view.dart';

void main() {
  runApp(const GiveTakeApp());
}

class GiveTakeApp extends StatefulWidget {
  const GiveTakeApp({super.key});

  @override
  State<GiveTakeApp> createState() => _GiveTakeAppState();
}

class _GiveTakeAppState extends State<GiveTakeApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final List<ProductService> _cartItems = [];

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  void _addToCart(ProductService product) {
    setState(() {
      _cartItems.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GiveTake',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: HomeView(
        onToggleTheme: _toggleTheme,
        cartItems: _cartItems,
        onAddToCart: _addToCart,
      ),
    );
  }
}
