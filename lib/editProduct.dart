// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class EditProductScreen extends StatefulWidget {
//   final String productId;
//   final DocumentSnapshot productData;

//   const EditProductScreen({
//     Key? key,
//     required this.productId,
//     required this.productData,
//   }) : super(key: key);

//   @override
//   State<EditProductScreen> createState() => _EditProductScreenState();
// }

// class _EditProductScreenState extends State<EditProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _priceController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.productData['name']);
//     _priceController = TextEditingController(text: widget.productData['price'].toString());
//   }

//   Future<void> _updateProduct() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await FirebaseFirestore.instance.collection('products').doc(widget.productId).update({
//           'name': _nameController.text,
//           'price': double.parse(_priceController.text),
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Product updated successfully')),
//         );
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update product: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Product'),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Product Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a product name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a price';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: _updateProduct,
//                 child: const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
