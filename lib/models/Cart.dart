class Cart {
  final String id;
  final String name;
  final double price;
  final double totalprice;
  final int quantity;  // New field added

  Cart({
    required this.id,
    required this.name,
    required this.price,
    required this.totalprice,
    required this.quantity,  // Added quantity to constructor
  });

  // Convert Firestore document to Cart object
  factory Cart.fromMap(Map<String, dynamic> data) {
    return Cart(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: data['price'] ?? 0.0,
      totalprice: data['totalprice'] ?? 0.0,
      quantity: data['quantity'] ?? 1,  // Default to 1 if quantity is not provided
    );
  }

  // Convert Cart object to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'totalprice': totalprice,
      'quantity': quantity,  // Include quantity in the map
    };
  }
}
