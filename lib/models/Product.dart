import 'package:cloud_firestore/cloud_firestore.dart';
import 'Category.dart';

class Product {
  final String id; // Optional for Firestore document ID
  final String name;
  final double price;
  final String detail;
  final Category category;
  //final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.detail,
    required this.category,
    // this.imageUrl,
  });

  // Convert a Product object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'detail': detail,
      'category': category.toMap(),
      // 'imageUrl': imageUrl,
    };
  }

  // Create a Product object from a Firestore document snapshot
  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Product(
      id: snapshot.id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0.0,
      detail: data['detail'] ?? '',
      category: Category.fromMap(data['category'] ?? {}),
      // imageUrl: data['imageUrl'],
    );
  }
}
