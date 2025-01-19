import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'Category.dart';

const uuid= Uuid();
final formatter = DateFormat('yyyy-MM-dd');

class Product {
  final String id; // Optional for Firestore document ID
  final String name;
  final double price;
  final String detail;
  final Category category;
  final double weight; 
  final int quantity;
  final DateTime productionDate; 
  final DateTime expireDate; 
  final bool isOnSale;
  final double newPrice;
  final bool isAllergenic; 
  //final String? imageUrl;

  Product({
    String? id, // Optional; generates a new UUID if not provided
    required this.name,
    required this.price,
    required this.detail,
    required this.category,
    required this.weight,
    required this.quantity,
    required this.productionDate,
    required this.expireDate,
    required this.isOnSale,
    required this.newPrice,
    required this.isAllergenic,
    //this.imageUrl,
  }): id = id ?? uuid.v4(); // Automatically generates a UUID if id is null

  // Convert a Product object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'detail': detail,
      'category': category.toMap(),
      'weight': weight,
      'quantity': quantity,
      'productionDate': formatter.format(productionDate),
      'dateOfExpire': formatter.format(expireDate),
      'isOnSale': isOnSale,
      'newPrice':newPrice,
      'isAllergenic': isAllergenic,
      // 'imageUrl': imageUrl,
    };
  }

  // Create a Product object from a Firestore document snapshot
  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Product(
      id: data['id'] ?? uuid.v4(), // Generates UUID if missing
      name: data['name'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      detail: data['detail'] ?? '',
      category: Category.fromMap(data['category'] ?? {}),
      weight: (data['weight'] ?? 0.000).toDouble(),
      quantity: data['quantity'] ?? 0,
      productionDate: data['dateOfProduction'] != null ? formatter.parse(data['dateOfProduction']): DateTime.now(),
      expireDate: data['dateOfExpire'] != null ? formatter.parse(data['dateOfExpire']): DateTime.now(),
      isOnSale: data['isOnSale'] ?? false,
      newPrice: (data['newPrice'] ?? 0.0).toDouble(),
      isAllergenic: data['isAllergenic'] ?? false,
      // imageUrl: data['imageUrl'],
    );
  }
}