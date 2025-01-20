import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditVoucherScreen extends StatefulWidget {
  final String voucherId;
  final String voucherCode;
  final double discount;

  const EditVoucherScreen({
    Key? key,
    required this.voucherId,
    required this.voucherCode,
    required this.discount,
  }) : super(key: key);

  @override
  _EditVoucherScreenState createState() => _EditVoucherScreenState();
}

class _EditVoucherScreenState extends State<EditVoucherScreen> {
  TextEditingController _voucherCodeController = TextEditingController();
  TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the voucher data passed from the previous screen
    _voucherCodeController.text = widget.voucherCode;
    _discountController.text = widget.discount.toString();
  }

  // Save or update voucher
  void _saveVoucher() async {
    if (_voucherCodeController.text.isNotEmpty && _discountController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('vouchers').doc(widget.voucherId).update({
          'voucherCode': _voucherCodeController.text,
          'discount': double.parse(_discountController.text),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Voucher updated successfully!')),
        );
        Navigator.pop(context); // Go back to the previous screen after saving
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Voucher'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voucher Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _voucherCodeController,
              decoration: const InputDecoration(
                labelText: 'Voucher Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(
                labelText: 'Discount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveVoucher,
              child: const Text('Update Voucher'),
            ),
          ],
        ),
      ),
    );
  }
}
