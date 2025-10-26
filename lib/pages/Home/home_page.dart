import 'package:gebeya/models/Products_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gebeya/constants/Colors.dart';
import 'package:gebeya/custom_widgets/Product_Card.dart';
import 'package:gebeya/custom_widgets/category_card.dart';
import 'package:gebeya/providers/product-provider.dart';
import 'package:gebeya/providers/cart-provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categoryNames = const [
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

  final List<String> images = const [
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

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.displayedProducts;
    final isLoading = productProvider.isLoading;

    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/auth_cover.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [gradient_start, gradient_end.withOpacity(0.3)],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.04, // Responsive top position
                  left: MediaQuery.of(context).size.width * 0.025, // Responsive left position
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: Icon(Icons.person,size: MediaQuery.of(context).size.width * 0.15,color: grey,)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Gues',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.06, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06, // Responsive font size
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
                            productProvider.loadProducts(category);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : products.isEmpty
                        ? const Center(child: Text('No products found'))
                        : GridView.builder(
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200, // Dynamic columns based on screen width
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
          ),
        ],
      ),
    );
  }

  String _resolveProductImagePath(Products product, String selectedCategory) {
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
  }
}
