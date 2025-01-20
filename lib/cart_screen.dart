// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smartgrocery/models/Product.dart';
// import 'package:smartgrocery/models/Cart.dart';
// import 'package:smartgrocery/provider/cartprovider.dart'; // Import the Cart model

// // Define providers to manage the voucher code and discount
// final voucherCodeProvider = StateProvider<String>((ref) => '');
// final discountProvider = StateProvider<double>((ref) => 0.0);

// class CartScreen extends ConsumerWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cartItems = ref.watch(cartProvider);
//     final voucherCode = ref.watch(voucherCodeProvider);
//     final discountAmount = ref.watch(discountProvider);

//     // Calculate the total price dynamically based on the product prices and quantities
//     double totalPrice = cartItems.fold(0.0, (sum, item) {
//       return sum + (item.product.price * item.quantity); // Multiply by quantity
//     });

//     double finalPrice = totalPrice - discountAmount;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cart'),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: cartItems.isEmpty
//           ? const Center(child: Text('Your cart is empty'))
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Display cart items
//                   ...cartItems
//                       .map((item) => _buildCartItem(item, ref))
//                       .toList(),
//                   const SizedBox(height: 20),

//                   // Add Coupon Section
//                   const Text('Add Coupon',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           onChanged: (value) {
//                             ref.read(voucherCodeProvider.state).state = value;
//                           },
//                           decoration: InputDecoration(
//                             hintText: 'Enter Voucher Code',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: () async {
//                           final discount = await _fetchVoucherDiscount(voucherCode);

//                           if (discount != null) {
//                             // Update the discount state
//                             ref.read(discountProvider.state).state = discount;

//                             // Update the UI or show success message
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Voucher applied successfully!'),
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Invalid voucher code!'),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.grey[300],
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 15),
//                         ),
//                         child: const Text('Apply',
//                             style: TextStyle(color: Colors.black)),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Price Details
//                   Text('Total Items: ${cartItems.length}'),
//                   const SizedBox(height: 10),
//                   Text('Price: \$${totalPrice.toStringAsFixed(2)}',
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),

//                   // Discount applied
//                   Text('Discount: -\$${discountAmount.toStringAsFixed(2)}'),
//                   const SizedBox(height: 10),

//                   // Calculate the final price with discount
//                   Text('Total Price: \$${finalPrice.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 18)),
//                   const SizedBox(height: 20),

//                   // Checkout Button
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     onPressed: () {
//                       _checkout(context, cartItems, finalPrice);
//                     },
//                     child: const Text('Checkout'),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   // Function to fetch voucher discount from Firestore
//   Future<double?> _fetchVoucherDiscount(String voucherCode) async {
//     try {
//       final voucherSnapshot = await FirebaseFirestore.instance
//           .collection('vouchers')
//           .where('voucherCode', isEqualTo: voucherCode)
//           .get();

//       if (voucherSnapshot.docs.isNotEmpty) {
//         final voucherData = voucherSnapshot.docs.first.data();
//         return voucherData['discount'] as double?;
//       } else {
//         return null; // Voucher not found
//       }
//     } catch (e) {
//       print('Error fetching voucher discount: $e');
//       return null;
//     }
//   }

//   // Build Cart Item widget
//   Widget _buildCartItem(CartItem item, WidgetRef ref) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.grey,
//             blurRadius: 6.0,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 30,
//             backgroundImage: AssetImage('assets/product.png'),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(item.product.name,
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold)),
//                 Text(item.product.detail,
//                     style: const TextStyle(color: Colors.grey)),
//               ],
//             ),
//           ),
//           Text('${item.product.price} EGP x ${item.quantity}',
//               style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(width: 10),
//           IconButton(
//             onPressed: () {
//               ref.read(cartProvider.notifier).removeProduct(item.product);
//             },
//             icon: const Icon(Icons.delete, color: Colors.red),
//           ),
//         ],
//       ),
//     );
//   }

//   void _checkout(
//       BuildContext context, List<CartItem> cartItems, double finalPrice) {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;

//     // Prepare the data for saving
//     List<Map<String, dynamic>> productData = cartItems.map((item) {
//       return {
//         'name': item.product.name,
//         'price': item.product.price,
//         'quantity': item.quantity, // Save the quantity as well
//       };
//     }).toList();

//     final cartData = {
//       'totalprice': finalPrice,
//       'products': productData,
//     };

//     firestore.collection('carts').add(cartData).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Cart saved successfully!')));

//       // Clear the cart after checkout
//       ref.read(cartProvider.notifier).clearCart();
//     }).catchError((error) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $error')));
//     });
//   }
// }import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/models/Product.dart';
import 'package:smartgrocery/models/Cart.dart';
import 'package:smartgrocery/provider/cartprovider.dart'; // Import the Cart model

// Define providers to manage the voucher code and discount
final voucherCodeProvider = StateProvider<String>((ref) => '');
final discountProvider = StateProvider<double>((ref) => 0.0);

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final voucherCode = ref.watch(voucherCodeProvider);
    final discountAmount = ref.watch(discountProvider);

    // Calculate the total price dynamically based on the product prices and quantities
    double totalPrice = cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity); // Multiply by quantity
    });

    double finalPrice = totalPrice - discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display cart items
                  ...cartItems
                      .map((item) => _buildCartItem(item, ref))
                      .toList(),
                  const SizedBox(height: 20),

                  // Add Coupon Section
                  const Text('Add Coupon',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            ref.read(voucherCodeProvider.state).state = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Voucher Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final discount =
                              await _fetchVoucherDiscount(voucherCode);

                          if (discount != null) {
                            // Validate if the voucher discount exceeds total price
                            if (discount > totalPrice) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Voucher exceeds total price!'),
                                ),
                              );
                              // Limit discount to total price
                              ref.read(discountProvider.state).state =
                                  totalPrice;
                            } else {
                              // Apply discount
                              ref.read(discountProvider.state).state = discount;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Voucher applied successfully!'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid voucher code!'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        child: const Text('Apply',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Voucher Removal Section
                  if (voucherCode.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Voucher Code: $voucherCode',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Reset voucher code and discount when removed
                            ref.read(voucherCodeProvider.state).state = '';
                            ref.read(discountProvider.state).state = 0.0;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Voucher removed successfully!'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Price Details
                  Text('Total Items: ${cartItems.length}'),
                  const SizedBox(height: 10),
                  Text('Price: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Discount applied
                  Text('Discount: -\$${discountAmount.toStringAsFixed(2)}'),
                  const SizedBox(height: 10),

                  // Calculate the final price with discount
                  Text('Total Price: \$${finalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),

                  // Checkout Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // Commented out the lines for adding to the database
                      // _checkout(context, cartItems, finalPrice);
                    },
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
    );
  }

  // Function to fetch voucher discount from Firestore
  Future<double?> _fetchVoucherDiscount(String voucherCode) async {
    try {
      final voucherSnapshot = await FirebaseFirestore.instance
          .collection('vouchers')
          .where('voucherCode', isEqualTo: voucherCode)
          .get();

      if (voucherSnapshot.docs.isNotEmpty) {
        final voucherData = voucherSnapshot.docs.first.data();
        return voucherData['discount'] as double?;
      } else {
        return null; // Voucher not found
      }
    } catch (e) {
      print('Error fetching voucher discount: $e');
      return null;
    }
  }

  // Build Cart Item widget
  Widget _buildCartItem(CartItem item, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/product.png'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(item.product.detail,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text('${item.product.price} EGP x ${item.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              ref.read(cartProvider.notifier).removeProduct(item.product);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  // void _checkout(
  //     BuildContext context, List<CartItem> cartItems, double finalPrice) {
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   // Prepare the data for saving
  //   List<Map<String, dynamic>> productData = cartItems.map((item) {
  //     return {
  //       'name': item.product.name,
  //       'price': item.product.price,
  //       'quantity': item.quantity, // Save the quantity as well
  //     };
  //   }).toList();

  //   final cartData = {
  //     'totalprice': finalPrice,
  //     'products': productData,
  //   };

  //   firestore.collection('carts').add(cartData).then((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Cart saved successfully!')));

  //     // Clear the cart after checkout
  //     ref.read(cartProvider.notifier).clearCart();
  //   }).catchError((error) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error: $error')));
  //   });
  // }
}
