import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/models/vouchers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActionPage extends StatefulWidget {
  final String userId;
  const ActionPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  final TextEditingController voucherCodeController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  Future<bool> isAdmin() async {
    // Check if the current user is an admin by comparing UID
    final user = FirebaseAuth.instance.currentUser;
    print('Current User UID: ${user?.uid}');
    return user != null &&
        user.uid == 'adminID'; // Replace 'adminID' with actual admin UID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Action'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = userData['name'] ?? 'Unknown Name';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User name: $userName',
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 20),

                // TextField for entering voucher details
                TextField(
                  controller: voucherCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Voucher Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: discountController,
                  decoration: const InputDecoration(
                    labelText: 'Discount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    _addVoucherToUser();
                  },
                  child: const Text('Add Voucher'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addVoucherToUser() async {
    final voucherCode = voucherCodeController.text.trim();
    final discount = double.tryParse(discountController.text.trim());
    final quantity = int.tryParse(quantityController.text.trim());

    if (voucherCode.isEmpty || discount == null || quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      bool isAdminUser = await isAdmin();
      print('Admin Check: $isAdminUser'); // Debugging admin check

      if (!isAdminUser) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('You are not authorized to add vouchers for other users.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get the user's data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final userData = userDoc.data() as Map<String, dynamic>;
      final userName = userData['name'] ?? 'Unknown Name';

      // Create a Voucher object with user data
      final voucher = Voucher(
        voucherCode: voucherCode,
        discount: discount,
        quantity: quantity,
        userId: widget.userId, // Add userId field
        userName: userName, // Add userName field
      );

      // Add the voucher under the user's subcollection
      final userVoucherRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('vouchers')
          .doc(); // Auto-generate document ID

      await userVoucherRef.set(voucher.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
