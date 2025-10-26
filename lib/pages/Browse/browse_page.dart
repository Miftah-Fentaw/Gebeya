import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/Colors.dart';
import '../../custom_widgets/Product_Card.dart';
import '../../custom_widgets/category_card.dart';
import '../../models/Products_model.dart';
import 'package:gebeya/providers/product-provider.dart';
import 'package:gebeya/providers/cart-provider.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final TextEditingController controller = TextEditingController();
  Timer? _debounce;

  final List<String> categoryNames = [
    'All',
    'Shoes',
    'Hat',
    'Jackets',
    'Pant',
    'Tshirt',
    'Watch',
    'Short',
    'Jewelery',
  ];
  final List<String> images = [
    'assets/Categories/All.jpg',
    'assets/Categories/Shoes.jpg',
    'assets/Categories/Hat.jpg',
    'assets/Categories/Jackets.jpg',
    'assets/Categories/pant.jpg',
    'assets/Categories/T-shirt.jpg',
    'assets/Categories/watch.jpg',
    'assets/Categories/Short.jpg',
    'assets/Categories/jewelery.jpg',
  ];

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).setSearchQuery(value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        try {
          final products = productProvider.displayedProducts;
          final isLoading = productProvider.isLoading;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, secondaryColor],
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                label: const Text(
                  'Search for products',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                filled: true,
                fillColor: Colors.white70,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(
                  images.length,
                  (index) => GestureDetector(
                    child: Categories(imagepath: images[index]),
                    onTap: () {
                        final category = categoryNames[index];
                      Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      ).setCategory(category);
                      controller.clear();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          imagePath: _resolveProductImagePath(
                            product,
                            productProvider.selectedCategory,
                          ),
                          name: product.name,
                          price: product.price,
                          originalPrice: null,
                          rating: product.rating,
                          sold: product.stock,
                          onAddToCart: () {
                            Provider.of<CartProvider>(
                              context,
                              listen: false,
                            ).addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart'),
                                duration: Duration(milliseconds: 800),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
        } catch (e) {
          print('Error in BrowsePage: $e');
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, secondaryColor],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 100,
                      color: Colors.red,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please try again later',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  String _resolveProductImagePath(Products product, String selectedCategory) {
    try {
      final folderMap = {
        'Watch': 'Watchs',
        'Tshirt': 'T-shirts',
        'Hat': 'Hats',
        'Jackets': 'Jackets',
        'Pant': 'Pants',
        'Short': 'Shorts',
        'Jewelery': 'Jewelery',
        'Shoes': 'Shoes',
      };

      final folder =
          folderMap[product.category] ?? folderMap[selectedCategory] ?? '';
      if (folder.isNotEmpty) {
        final id = (product.id <= 0) ? 1 : product.id;
        return 'assets/Products/$folder/img$id.jpg';
      }

      if (product.image.isNotEmpty) return 'assets/images/${product.image}';
      return 'assets/images/profile.jpg';
    } catch (e) {
      print('Error resolving image path: $e');
      return 'assets/images/profile.jpg';
    }
  }
}
