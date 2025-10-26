class Products {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String image; // image filename
  final int stock;
  final double rating;

  Products({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.stock,
    required this.rating,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'] is int ? json['id'] : (json['id'] as num).toInt(),
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      stock: json['stock'] is int ? json['stock'] : (json['stock'] ?? 0) as int,
      rating: (json['rating'] as num).toDouble(),
    );
  }
}