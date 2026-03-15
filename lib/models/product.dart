class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'İsimsiz Ürün',
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
      category: json['category'] ?? 'Diğer',
    );
  }
}