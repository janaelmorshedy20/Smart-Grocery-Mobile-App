import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'addProduct.dart';


class AdminDashboard extends StatelessWidget {

//   Future<int> getProductCount() async {
//   try {
//     // Fetch the documents in the 'products' collection
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
//     return snapshot.docs.length;
//   } catch (e) {
//     print('Error fetching product count: $e');
//     return 0; // Return 0 in case of an error
//   }
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Dashboard Header
          Container(
            color: Colors.green.shade100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Categories'),
                Text('Products'),
                Text('Orders'),
              ],
            ),
          ),

          // Static GridView
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                children: [
                  _buildDashboardCard(
                    context,
                    title: 'Categories',
                    value: '3',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const CategoriesPage()),
                      // );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Products',
                    value: '9',
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const AddProductScreen()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Users',
                    value: '55',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const UsersPage()),
                      // );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Orders',
                    value: '2',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const OrdersPage()),
                      // );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Active Users',
                    value: '34',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const ActiveUsersPage()),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
