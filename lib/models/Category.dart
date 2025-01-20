import 'package:cloud_firestore/cloud_firestore.dart';

class Category {

  final String id;
  final String name;

  Category({required this.id, required this.name});

  // Convert Firestore document to Category object

   factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
  // factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      // id: data['id'],
      id: snapshot.id,
      name: data['name'] ?? '',
    );
  }

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
    id: data['id'] ?? '', // Use default empty string if id is null
    name: data['name'] ?? '', // Use default empty string if name is null
    );
  }

    // Convert Category object to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}