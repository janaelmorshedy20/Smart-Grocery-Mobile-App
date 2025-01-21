import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/actionpage.dart'; // Import ActionPage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgrocery/Login.dart';
import 'package:smartgrocery/orders.dart';
import 'package:smartgrocery/products.dart';
import 'package:smartgrocery/users.dart'; // Import UsersTableScreen
import 'package:smartgrocery/vouchersActions.dart';
import 'addProduct.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // Fetch the user count from Firestore
  Future<int> getUserCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching user count: $e');
      return 0;
    }
  }

  // Fetch the order count from Firestore
  Future<int> getOrderCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching order count: $e');
      return 0;
    }
  }

  // Fetch the voucher count from Firestore
  Future<int> getVoucherCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('vouchers').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching voucher count: $e');
      return 0;
    }
  }

  // Fetch the product count from Firestore
  Future<int> getProductCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching product count: $e');
      return 0;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen2(),
        ),
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
                        builder: (context) => const AddProductScreen(),
                      ),
                    );
                  },
                ),
                _buildHeaderItem(
                  context,
                  title: 'Add Vouchers',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActionPage(),
                      ),
                    );
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
                      print('Categories tapped');
                    },
                  ),
                  // FutureBuilder for dynamic Product count
                  FutureBuilder<int>(
                    future: getProductCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildDashboardCard(
                          context,
                          title: 'Products',
                          value: 'Loading...',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductsPage(),
                              ),
                            );
                          },
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildDashboardCard(
                          context,
                          title: 'Products',
                          value: 'Error',
                          onTap: () {},
                        );
                      }

                      final productCount = snapshot.data ?? 0;
                      return _buildDashboardCard(
                        context,
                        title: 'Products',
                        value: '$productCount',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductsPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // FutureBuilder to load user count
                  FutureBuilder<int>(
                    future: getUserCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildDashboardCard(
                          context,
                          title: 'Users',
                          value: 'Loading...',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UsersTableScreen(),
                              ),
                            );
                          },
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildDashboardCard(
                          context,
                          title: 'Users',
                          value: 'Error',
                          onTap: () {},
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
                              builder: (context) => const UsersTableScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // FutureBuilder for dynamic Order count
                  FutureBuilder<int>(
                    future: getOrderCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildDashboardCard(
                          context,
                          title: 'Orders',
                          value: 'Loading...',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllOrdersPage(),
                              ),
                            );
                          },
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildDashboardCard(
                          context,
                          title: 'Orders',
                          value: 'Error',
                          onTap: () {},
                        );
                      }

                      final orderCount = snapshot.data ?? 0;
                      return _buildDashboardCard(
                        context,
                        title: 'Orders',
                        value: '$orderCount',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllOrdersPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // FutureBuilder for dynamic Voucher count
                  FutureBuilder<int>(
                    future: getVoucherCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildDashboardCard(
                          context,
                          title: 'Vouchers',
                          value: 'Loading...',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VoucherActionScreen(),
                              ),
                            );
                          },
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildDashboardCard(
                          context,
                          title: 'Vouchers',
                          value: 'Error',
                          onTap: () {},
                        );
                      }

                      final voucherCount = snapshot.data ?? 0;
                      return _buildDashboardCard(
                        context,
                        title: 'Vouchers',
                        value: '$voucherCount',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const VoucherActionScreen(),
                            ),
                          );
                        },
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
