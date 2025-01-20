import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/actionpage.dart'; // Import ActionPage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgrocery/Login.dart';
import 'package:smartgrocery/products.dart';
import 'package:smartgrocery/users.dart'; // Import UsersTableScreen
import 'package:smartgrocery/vouchersActions.dart';
import 'addProduct.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatelessWidget {
  // Fetch the user count from Firestore
  Future<int> getUserCount() async {
    try {
      // Fetch users collection and count the documents
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching user count: $e');
      return 0; // Return 0 if there is an error
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Clear the session if necessary
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginScreen2()), // Navigate to login screen after logout
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dashboard Header
          Container(
            color: Colors.green.shade100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeaderItem(
                  context,
                  title: 'Add Categories',
                  onTap: () {
                    // Navigate to Categories Page
                    print('Categories clicked');
                  },
                ),
                _buildHeaderItem(
                  context,
                  title: 'Add Products',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProductScreen(),
                      ),
                    );
                  },
                ),
                _buildHeaderItem(
                  context,
                  title: 'Orders',
                  onTap: () {
                    // Navigate to Orders Page
                    print('Orders clicked');
                  },
                ),
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
                      // Handle Categories card tap
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Products',
                    value: '9',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductsPage()),
                      );
                    },
                  ),
                  // FutureBuilder to load user count
                  FutureBuilder<int>(
                    future: getUserCount(), // Fetch the actual user count
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildDashboardCard(
                          context,
                          title: 'Users',
                          value:
                              'Loading...', // Show loading text until data is fetched
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UsersTableScreen()),
                            );
                          },
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildDashboardCard(
                          context,
                          title: 'Users',
                          value: 'Error',
                          onTap: () {
                            // Handle error (e.g., navigate to an error page)
                          },
                        );
                      }

                      final userCount = snapshot.data ?? 0;
                      return _buildDashboardCard(
                        context,
                        title: 'Users',
                        value: '$userCount',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UsersTableScreen()),
                          );
                        },
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Orders',
                    value: '2',
                    onTap: () {
                      // Handle Orders card tap
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Add vouchers',
                    value: '34',
                    onTap: () {
                      // Navigate to ActionPage for adding vouchers
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActionPage(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Vouchers',
                    value: '3',
                    onTap: () {
                      // Navigate to ActionPage for adding vouchers
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VoucherActionScreen(),
                        ),
                      );
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

  Widget _buildHeaderItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
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
