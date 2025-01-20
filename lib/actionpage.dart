import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/models/vouchers.dart'; // Import Voucher model

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  final TextEditingController voucherCodeController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Voucher'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Voucher Details:',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 20),

            // TextField for entering voucher code
            TextField(
              controller: voucherCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Voucher Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // TextField for entering discount
            TextField(
              controller: discountController,
              decoration: const InputDecoration(
                labelText: 'Discount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _addVoucherToAllUsers,
              child: const Text('Add Voucher'),
            ),
          ],
        ),
      ),
    );
  }

  void _addVoucherToAllUsers() async {
    final voucherCode = voucherCodeController.text.trim();
    final discount = double.tryParse(discountController.text.trim());

    if (voucherCode.isEmpty || discount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create a Voucher object
      final voucher = Voucher(
        voucherCode: voucherCode,
        discount: discount,
      );

      // Add the voucher to the 'vouchers' collection (not specific to any user)
      final voucherRef = FirebaseFirestore.instance
          .collection('vouchers')
          .doc(); // Auto-generate document ID

      await voucherRef.set(voucher.toMap());

      // Clear the text fields after successful voucher addition
      voucherCodeController.clear();
      discountController.clear();

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
