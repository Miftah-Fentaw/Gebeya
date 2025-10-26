import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
 final String imagepath;
  const Categories({super.key, required this.imagepath, });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final categorySize = screenWidth * 0.15; // ~15% of screen width

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagepath,
          fit: BoxFit.cover,
          width: categorySize,
          height: categorySize,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: categorySize,
              height: categorySize,
              color: Colors.grey[300],
              child: Icon(
                Icons.category,
                color: Colors.grey[600],
                size: categorySize * 0.4, // Proportional icon size
              ),
            );
          },
        ),
      ),
    );
  }
}
