/// Product model
/// This class represents a product in the system.
class Product {
  int id;
  String name;
  int price;
  int quantity;
  String cover;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
  });
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    price: json['price'],
    quantity: json['quantity'],
    cover: json['cover'],
  );
  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'quantity': quantity,
    'cover': cover,
  };
}
