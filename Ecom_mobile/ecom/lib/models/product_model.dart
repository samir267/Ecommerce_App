class Product {
  final int id;
  final String name;
  final String description;
  final int quantity;
  final String image;
  final double price;
  final int categoryId;
  final int userId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.image,
    required this.price,
    required this.categoryId,
    required this.userId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      image: json['image'],
      price: json['price'].toDouble(),
      categoryId: json['categoryId'],
      userId: json['userId'],
    );
  }
  
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, image: $image)';
  }
}
