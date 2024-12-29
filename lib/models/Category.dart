class Category {
  final String name;
  final String id;

  Category({required this.name, required this.id});

  // Convert Firestore document to Category object
  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      name: data['name'] ?? '',
      id: data['id'] ?? '',
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