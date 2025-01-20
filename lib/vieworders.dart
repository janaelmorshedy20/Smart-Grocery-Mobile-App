import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewOrderPage extends StatelessWidget {
  // Fetch orders by customer name
  Future<String> _fetchCustomerName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          return userDoc['name']; // Return the customer name
        } else {
          print('User profile not found');
          return '';
        }
      } else {
        print('User not logged in');
        return '';
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return '';
    }
  }

  // Fetch orders based on customer name
  Future<List<Map<String, dynamic>>> _fetchOrdersByCustomerName(String customerName) async {
    try {
      // Query orders where the customerName matches the provided name
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders') // Access the orders collection
          .where('customerName', isEqualTo: customerName)  // Filter by customerName
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
        title: const Text('View Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<String>(
        future: _fetchCustomerName(),  // Fetch customer name
        builder: (context, nameSnapshot) {
          if (nameSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (nameSnapshot.hasError) {
            return const Center(child: Text('Error fetching customer name'));
          }
          if (!nameSnapshot.hasData || nameSnapshot.data!.isEmpty) {
            return const Center(child: Text('No customer name found'));
          }

          final customerName = nameSnapshot.data!;
          return FutureBuilder<List<Map<String, dynamic>>>( 
            future: _fetchOrdersByCustomerName(customerName),  // Fetch orders based on customer name
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching orders'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No orders found for $customerName'));
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
                            Text(
                              'Order Date: ${order['orderDate'] != null ? (order['orderDate'] as Timestamp).toDate() : 'N/A'}',
                            ),
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
          );
        },
      ),
    );
  }
}
