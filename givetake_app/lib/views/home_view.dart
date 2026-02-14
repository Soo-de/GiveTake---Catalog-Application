import 'package:flutter/material.dart';
import '../models/product_service.dart';
import '../services/api_service.dart';
import '../components/product_card.dart';
import '../components/category_chip.dart';
import '../components/empty_state.dart';
import 'product_detail_view.dart';
import 'cart_view.dart';

class HomeView extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final List<ProductService> cartItems;
  final Function(ProductService) onAddToCart;

  /* Constructer */
  const HomeView({
    super.key,
    required this.onToggleTheme,
    required this.cartItems,
    required this.onAddToCart,
  });

  /* Create State */
  @override
  State<HomeView> createState() => _HomeViewState();
}

/* State Class */
class _HomeViewState extends State<HomeView> {
  List<ProductService> _allProducts = [];
  List<ProductService> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _sortOption = 'default';
  String _searchQuery = '';
  bool _isLoading = true;
  String? _error;
  int _currentIndex = 0;

  final TextEditingController _searchController = TextEditingController();

  /* initState Method */
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /* Load Products */
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final products = await ApiService.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _categories = ApiService.getCategories(products);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /* Apply Filters */
  void _applyFilters() {
    List<ProductService> result = List.from(_allProducts);

    // Category Filter
    result = ApiService.filterByCategory(result, _selectedCategory);

    // Search Filter
    result = ApiService.searchProducts(result, _searchQuery);

    // Sorting
    result = ApiService.sortProducts(result, _sortOption);

    setState(() {
      _filteredProducts = result;
    });
  }

  /* Category Selected */
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  /* Sort Changed */
  void _onSortChanged(String sortOption) {
    setState(() {
      _sortOption = sortOption;
    });
    _applyFilters();
  }

  /* Search Changed */
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  /* Dispose */
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /* Build Method */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          CartView(
            cartItems: widget.cartItems,
            onRemove: (product) {
              setState(() {
                widget.cartItems.remove(product);
              });
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: widget.cartItems.isNotEmpty,
              label: Text('${widget.cartItems.length}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: widget.cartItems.isNotEmpty,
              label: Text('${widget.cartItems.length}'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Sepetim',
          ),
        ],
      ),
    );
  }

  /* Build Home Content */
  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        children: [
          /* AppBar Content */
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GiveTake',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Row(
                  children: [
                    /* Sort Button */
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.sort,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onSelected: _onSortChanged,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'default',
                          child: Text('Varsayılan'),
                        ),
                        const PopupMenuItem(
                          value: 'price_low',
                          child: Text('Fiyat: Düşükten Yükseğe'),
                        ),
                        const PopupMenuItem(
                          value: 'price_high',
                          child: Text('Fiyat: Yüksekten Düşüğe'),
                        ),
                        const PopupMenuItem(
                          value: 'rating',
                          child: Text('En Yüksek Puan'),
                        ),
                      ],
                    ),
                    /* Theme Toggle Button */
                    IconButton(
                      icon: Icon(
                        Theme.of(context).brightness == Brightness.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: widget.onToggleTheme,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /* Search Bar */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          /* Category Chips */
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CategoryChip(
                    label: _categories[index],
                    isSelected: _selectedCategory == _categories[index],
                    onTap: () => _onCategorySelected(_categories[index]),
                  ),
                );
              },
            ),
          ),

          /* Product Grid */
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  /* Build Product Grid */
  Widget _buildProductGrid() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 16),

            Text(
              'Bağlantı hatası',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Veriler yüklenemedi',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    /* Empty State */
    if (_filteredProducts.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'Ürün bulunamadı',
        subtitle: 'Farklı bir arama veya kategori deneyin',
      );
    }

    /* Product Grid */
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: _filteredProducts[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailView(
                  product: _filteredProducts[index],
                  onAddToCart: widget.onAddToCart,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
