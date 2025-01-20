import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/models/Cart.dart';
import 'package:smartgrocery/provider/cartprovider.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final double finalPrice;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.finalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
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
                      .map((item) => _buildCartItem(item))
                      .toList(),

                  const SizedBox(height: 20),

                  // Price Details
                  Text('Total Items: ${cartItems.length}'),
                  const SizedBox(height: 10),
                  Text('Price: \$${finalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Final Price (same as the total price in this case)
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
                      _checkout(context, cartItems, finalPrice);
                    },
                    child: const Text('Place Order'),
                  ),
                ],
              ),
            ),
    );
  }

  // Function to handle placing the order
  Future<void> _checkout(
      BuildContext context, List<CartItem> cartItems, double totalPrice) async {
    try {
      // Create the order object
      final orderData = {
        'items': cartItems.map((item) {
          return {
            'productId': item.product.id,
            'quantity': item.quantity,
            'price': item.product.price,
          };
        }).toList(),
        'totalPrice': totalPrice,
        'status': 'Pending',
        'orderDate': Timestamp.now(),
      };

      // Add the order to Firestore
      final orderRef = await FirebaseFirestore.instance.collection('orders').add(orderData);

      // Clear the cart after successful checkout
      await FirebaseFirestore.instance.collection('carts').doc(orderRef.id).delete();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
        ),
      );

      // Navigate back to the home page (or another page after successful order)
      Navigator.popUntil(context, ModalRoute.withName('/'));

    } catch (e) {
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error placing the order. Please try again!'),
        ),
      );
    }
  }

  // Build Cart Item widget (similar to CartScreen)
  Widget _buildCartItem(CartItem item) {
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
              // Add functionality for item removal (assuming you have a CartProvider)
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
