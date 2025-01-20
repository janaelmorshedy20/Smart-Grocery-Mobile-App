import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/models/Cart.dart';

class Order {
  final String id;
  final List<Cart> items;
  final double totalPrice;
  final String status;
  final DateTime orderDate;
  final String customerName;
  final String shippingAddress;
  final String phoneNumber;
  final String paymentMethod;  // New field added

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    required this.customerName,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.paymentMethod,  // Added paymentMethod to constructor
  });

  // Convert Firestore document to Order object
  factory Order.fromMap(Map<String, dynamic> data) {
    return Order(
      id: data['id'] ?? '',  // Optional: id could be null
      items: (data['items'] as List)
          .map((item) => Cart.fromMap(item)) // Convert each cart item using Cart.fromMap
          .toList(),
      totalPrice: data['totalPrice'] ?? 0.0,  // Set default to 0 if missing
      status: data['status'] ?? 'Pending',  // Default to 'Pending' if missing
      orderDate: (data['orderDate'] as Timestamp).toDate(),  // Ensure timestamp conversion
      customerName: data['customerName'] ?? '',
      shippingAddress: data['shippingAddress'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      paymentMethod: data['paymentMethod'] ?? 'Cash on Delivery',  // Default to 'Cash on Delivery' if missing
    );
  }

  // Convert Order object to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),  // Convert cart items back to Map
      'totalPrice': totalPrice,
      'status': status,
      'orderDate': Timestamp.fromDate(orderDate),  // Convert orderDate to Timestamp
      'customerName': customerName,
      'shippingAddress': shippingAddress,
      'phoneNumber': phoneNumber,
      'paymentMethod': paymentMethod,  // Include paymentMethod in the map
    };
  }
}
