import 'Cart.dart';
class Checkout {
  final String id;
  final String userId;
  final List<Cart> items;
  final double totalAmount;
  final String status;

  Checkout({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
  });

  // Convert Firestore document to Checkout object
  factory Checkout.fromMap(Map<String, dynamic> data) {
    return Checkout(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      items: (data['items'] as List)
              .map((item) => Cart.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: data['totalAmount'] ?? 0.0,
      status: data['status'] ?? 'Pending',
    );
  }

  // Convert Checkout object to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
    };
  }
}
