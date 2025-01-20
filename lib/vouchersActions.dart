import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'editvoucher.dart'; // Import EditVoucherScreen

class VoucherActionScreen extends StatefulWidget {
  const VoucherActionScreen({Key? key}) : super(key: key);

  @override
  _VoucherActionScreenState createState() => _VoucherActionScreenState();
}

class _VoucherActionScreenState extends State<VoucherActionScreen> {

  // Fetch vouchers from Firestore
  Future<List<DocumentSnapshot>> _fetchVouchers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('vouchers').get();
    return snapshot.docs;
  }

  // Delete voucher
  void _deleteVoucher(String voucherId) async {
    try {
      await FirebaseFirestore.instance
          .collection('vouchers')
          .doc(voucherId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voucher deleted successfully!')),
      );

      setState(() {});  // Refresh the page after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Actions'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchVouchers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No vouchers found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              // GridView now scrolls independently without the need for Expanded
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final voucher = snapshot.data![index];
                final voucherId = voucher.id;
                final voucherCode = voucher['voucherCode'];
                final discount = voucher['discount'];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(voucherCode, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('\$${discount.toString()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Navigate to EditVoucherScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditVoucherScreen(
                                      voucherId: voucherId,
                                      voucherCode: voucherCode,
                                      discount: discount,
                                    ),
                                  ),
                                ).then((_) {
                                  // Reload vouchers after returning from EditVoucherScreen
                                  setState(() {});
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteVoucher(voucherId);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
