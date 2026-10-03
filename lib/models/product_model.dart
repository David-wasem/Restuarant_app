class Product {
  final String title;
  final String description;
  final String category;
  final double price;
  final List<String>? images;

  Product({
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.images,
  });

  factory Product.formJson(Map<String, dynamic> jsonData) {
    return Product(
      title: jsonData['title'],
      description: jsonData['description'],
      category: jsonData['category'],
      price: (jsonData['price'] as num).toDouble(),
      images: (jsonData['images'] as List<dynamic>?)
          ?.map((image) => image as String)
          .toList(),
    );
  }
}
