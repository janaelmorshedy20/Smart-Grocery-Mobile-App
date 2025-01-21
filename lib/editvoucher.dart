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
  final TextEditingController _voucherCodeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _voucherCodeController.text = widget.voucherCode;
    _discountController.text = widget.discount.toString();
  }

  // Save or update voucher
  void _saveVoucher() async {
    final voucherCode = _voucherCodeController.text.trim();
    final discountText = _discountController.text.trim();
    final discount = double.tryParse(discountText);

    if (voucherCode.isEmpty || discount == null) {
      _showSnackbar('Please fill all fields correctly', Colors.red);
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('vouchers').doc(widget.voucherId).update({
        'voucherCode': voucherCode,
        'discount': discount,
      });

      _showSnackbar('Voucher updated successfully!', Colors.green);
      Navigator.pop(context); // Go back after saving
    } catch (e) {
      _showSnackbar('Error: $e', Colors.red);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Voucher',
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
              'Voucher Details:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Voucher Code Field
            _buildInputField(
              controller: _voucherCodeController,
              labelText: 'Voucher Code',
              icon: Icons.confirmation_number,
            ),
            const SizedBox(height: 15),

            // Discount Field
            _buildInputField(
              controller: _discountController,
              labelText: 'Discount Amount',
              icon: Icons.percent,
              isNumeric: true,
            ),
            const SizedBox(height: 25),

            // Update Voucher Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveVoucher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update Voucher',
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
}
