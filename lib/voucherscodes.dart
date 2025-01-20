import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgrocery/models/vouchers.dart'; // Import Voucher model

class VouchersPage extends StatelessWidget {
  const VouchersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Vouchers'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('vouchers').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No vouchers available.'));
          }

          final vouchers = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                final voucherData =
                    vouchers[index].data() as Map<String, dynamic>;
                final voucherCode = voucherData['voucherCode'] ?? 'N/A';
                final discount = voucherData['discount'] ?? 0;

                return ListTile(
                  title: Text('Voucher Code: $voucherCode'),
                  subtitle: Text('Discount: $discount EGP'),
                  onTap: () {
                    // Here you can handle the voucher selection action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You selected $voucherCode'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
