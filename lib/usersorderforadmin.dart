import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrdersPage extends StatelessWidget {
  final String userName;

  const UserOrdersPage({Key? key, required this.userName}) : super(key: key);

  // Fetch orders based on customer name
  Future<List<Map<String, dynamic>>> _fetchOrdersByUserName(String userName) async {
    try {
      // Query orders where the customerName matches the provided userName
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders') // Access the orders collection
          .where('customerName', isEqualTo: userName)  // Filter by customerName
          .get();

      List<Map<String, dynamic>> orders = [];

      for (var doc in ordersSnapshot.docs) {
        // Get the items array from each order document
        List<dynamic> items = doc['items'] ?? [];

        for (var item in items) {
          // Add item details to the orders list
          orders.add({
            'name': item['name'] ?? 'N/A',
            'price': item['price'] ?? 'N/A',
            'orderDate': doc['orderDate'], // Get orderDate from the parent order document
            'status': doc['status'] ?? 'N/A',
            'totalPrice': doc['totalPrice'] ?? 'N/A',
          });
        }
      }

      return orders;
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userName\'s Orders'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrdersByUserName(userName),  // Fetch orders for the specific user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching orders'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found for $userName'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text('Order Name: ${order['name'] ?? 'N/A'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${order['price'] ?? 'N/A'}'),
                        Text('Order Date: ${order['orderDate'] != null ? (order['orderDate'] as Timestamp).toDate() : 'N/A'}'),
                        Text('Status: ${order['status'] ?? 'N/A'}'),
                        Text('Total Price: \$${order['totalPrice'] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
