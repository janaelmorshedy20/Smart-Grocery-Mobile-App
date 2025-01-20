import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/provider/cartprovider.dart';
import 'models/Product.dart';
import 'models/Cart.dart'; // Import the Cart model

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    // Calculate the total price dynamically based on the product prices and quantities
    double totalPrice = cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity); // Multiply by quantity
    });

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
                        onPressed: () {
                          // Apply coupon functionality can be added here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Voucher applied successfully!'),
                            ),
                          );
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

                  // Price Details
                  Text('Total Items: ${cartItems.length}'),
                  const SizedBox(height: 10),
                  Text('Price: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Assuming no discount applied for now
                  const SizedBox(height: 10),
                  Text('Total Price: \$${totalPrice.toStringAsFixed(2)}',
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
                      _checkout(context, cartItems, totalPrice);
                    },
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
    );
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

  void _checkout(
      BuildContext context, List<CartItem> cartItems, double finalPrice) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Prepare the data for saving
    List<Map<String, dynamic>> productData = cartItems.map((item) {
      return {
        'name': item.product.name,
        'price': item.product.price,
        'quantity': item.quantity, // Save the quantity as well
      };
    }).toList();

    final cartData = {
      'totalprice': finalPrice,
      'products': productData,
    };

    firestore.collection('carts').add(cartData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cart saved successfully!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    });
  }
}
