import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/models/vouchers.dart'; // Import Voucher model

class ActionPage extends StatefulWidget {
  const ActionPage({super.key});

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
        title: const Text('Add Voucher',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Enter Voucher Details:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Voucher Code Field
            _buildInputField(
              controller: voucherCodeController,
              labelText: 'Enter Voucher Code',
              icon: Icons.confirmation_number,
            ),
            const SizedBox(height: 15),

            // Discount Field
            _buildInputField(
              controller: discountController,
              labelText: 'Discount Amount',
              icon: Icons.percent,
              isNumeric: true,
            ),
            const SizedBox(height: 25),

            // Add Voucher Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _addVoucherToAllUsers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Voucher',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI Helper for Input Fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isNumeric = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.green),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Function to Add Voucher to Firestore
  void _addVoucherToAllUsers() async {
    final voucherCode = voucherCodeController.text.trim();
    final discount = double.tryParse(discountController.text.trim());

    if (voucherCode.isEmpty || discount == null) {
      _showSnackbar('Please fill all fields correctly', Colors.red);
      return;
    }

    try {
      // Create a Voucher object
      final voucher = Voucher(
        voucherCode: voucherCode,
        discount: discount,
      );

      // Add the voucher to Firestore
      final voucherRef = FirebaseFirestore.instance.collection('vouchers').doc();
      await voucherRef.set(voucher.toMap());

      // Clear input fields after success
      voucherCodeController.clear();
      discountController.clear();

      _showSnackbar('Voucher added successfully!', Colors.green);
    } catch (e) {
      _showSnackbar('Error: ${e.toString()}', Colors.red);
    }
  }

  // Snackbar Helper Function
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
