import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String id;
  final String name;
  final double price;
  final double totalprice;

  Cart({
    required this.id,
    required this.name,
    required this.price,
    required this.totalprice,
  });

  // Convert Firestore document to Cart object
  factory Cart.fromMap(Map<String, dynamic> data) {
    return Cart(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: data['price'] ?? 0.0,
      totalprice: data['totalprice'] ?? 0.0,
    );
  }

  // Convert Cart object to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'totalprice': totalprice,
    };
  }
}
