class ProductCart {
  final int id;
  final String name;
  final String description;
  final int? quantity; // Nullable
  final String image;
  final double price;
  final int userId;

  ProductCart({
    required this.id,
    required this.name,
    required this.description,
    this.quantity, // Nullable
    required this.image,
    required this.price,
    required this.userId,
  });

  factory ProductCart.fromJson(Map<String, dynamic> json) {
    return ProductCart(
      id: json['id'] ?? 0, // Default to 0 if id is null
      name: json['name'] ?? 'Unknown', // Default to 'Unknown'
      description: json['description'] ?? 'No description', // Default to 'No description'
      quantity: json['quantity'] as int?, // Allow null
      image: json['image'] ?? '', // Default to empty string
      price: (json['price'] ?? 0.0).toDouble(), // Default to 0.0
      userId: json['userId'] ?? 0, // Default to 0
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, quantity: $quantity, price: $price, image: $image)';
  }
}
