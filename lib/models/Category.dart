import 'package:cloud_firestore/cloud_firestore.dart';

class Category {

  final String id;
  final String name;
  final String imageUrl;

  Category({required this.id, required this.name, required this.imageUrl,});

  // Convert Firestore document to Category object
  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Category(
      // id: data['id'],
      id: snapshot.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '', 
    );
  }

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: data['id'], 
      name: data['name'] ?? '', 
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert Category object to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}