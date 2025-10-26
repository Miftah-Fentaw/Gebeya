import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final double price;
  final double? originalPrice;
  final double rating;
  final int sold;
  final VoidCallback onAddToCart; 

  const ProductCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.sold, required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4; // ~40% of screen width
    final imageHeight = cardWidth * 0.8; // Proportional height

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: imageHeight,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                    size: imageHeight * 0.3, // Proportional icon size
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    if (index < rating.floor()) {
                      return const Icon(Icons.star, color: Colors.orange, size: 14);
                    } else if (index < rating) {
                      return const Icon(Icons.star_half, color: Colors.orange, size: 14);
                    } else {
                      return const Icon(Icons.star_border, color: Colors.orange, size: 14);
                    }
                  }),
                ),
                const SizedBox(width: 5),
                Text(
                  '$sold sold',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 5),
                if (originalPrice != null)
                  Text(
                    '\$${originalPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 80,
                  height: 30,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red ,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('add to cart', style: TextStyle(color: Colors.white, fontSize: 10)),
                      SizedBox(width: 2),
                      Icon(Icons.add, color: Colors.white, size: 12),
                    ],
                  ),
                ),
              ),
            ),
            onTap: onAddToCart,
          ),
        ],
      ),
    );
  }
}
