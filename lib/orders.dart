import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllOrdersPage extends StatelessWidget {
  // Fetch orders from Firestore
  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    try {
      // Fetch all orders
      final ordersSnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      return ordersSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching orders'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!;

          return Column(
            children: [
              // Order Count Card
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  
                ),
              ),
              // Order List
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final items =
                        order['items'] as List<dynamic>? ?? []; // Ensure items exist

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8.0),
                              const Text(
                                'Items:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // Iterate over items array
                              ...items.map((item) {
                                return ListTile(
                                  title: Text('Name: ${item['name'] ?? 'N/A'}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Price: \$${item['price'] ?? 'N/A'}'),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const Divider(),
                              Text(
                                  'Order Date: ${(order['orderDate'] as Timestamp?)?.toDate() ?? 'N/A'}'),
                              Text(
                                  'Phone Number: ${order['phoneNumber'] ?? 'N/A'}'),
                              Text(
                                  'Shipping Address: ${order['shippingAddress'] ?? 'N/A'}'),
                              Text('Status: ${order['status'] ?? 'N/A'}'),
                              Text(
                                  'Total Price: \$${order['totalPrice'] ?? 'N/A'}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
