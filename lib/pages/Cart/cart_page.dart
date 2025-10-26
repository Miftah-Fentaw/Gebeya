import 'package:gebeya/constants/Colors.dart';
import 'package:gebeya/models/Products_model.dart';
import 'package:gebeya/providers/cart-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.items.values.toList();
        final totalItems = cartProvider.totalItems;
        
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text('My Cart ($totalItems)', style: TextStyle(
              color: black,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              if (cartItems.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear_all, color: black),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Clear Cart'),
                        content: Text('Are you sure you want to remove all items from your cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              cartProvider.clearCart();
                              Navigator.pop(context);
                            },
                            child: Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
              )
            ),
            width: double.infinity,
            height: double.infinity,
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add some products to get started',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: cartItems.map((cartItem) => _buildCartItem(cartItem)).toList(),
                            ),
                          ),
                        ),
                      ),
                      _buildCartSummary(cartItems),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              _resolveProductImagePath(cartItem.product),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  '\$${cartItem.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 20),
                            onPressed: () {
                              if (cartItem.quantity > 1) {
                                Provider.of<CartProvider>(context, listen: false)
                                    .updateQuantity(cartItem.product, cartItem.quantity - 1);
                              } else {
                                Provider.of<CartProvider>(context, listen: false)
                                    .removeFromCart(cartItem.product);
                              }
                            },
                          ),
                          Container(
                            width: 40,
                            child: Text(
                              '${cartItem.quantity}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 20),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .updateQuantity(cartItem.product, cartItem.quantity + 1);
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .removeFromCart(cartItem.product);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(List<CartItem> cartItems) {
    final totalAmount = cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${cartItems.fold<int>(0, (sum, item) => sum + item.quantity)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Checkout functionality coming soon!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _resolveProductImagePath(Products product) {
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

    final folder = folderMap[product.category] ?? '';
    if (folder.isNotEmpty) {
      final id = (product.id <= 0) ? 1 : product.id;
      return 'assets/Products/$folder/img$id.jpg';
    }

    if (product.image.isNotEmpty) return 'assets/images/${product.image}';
    return 'assets/images/profile.jpg';
  }
}