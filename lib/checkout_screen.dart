import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/models/Cart.dart';
import 'package:smartgrocery/provider/cartprovider.dart';
import 'placeOrder_screen.dart';

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
                  ...cartItems.map((item) => _buildCartItem(item)).toList(),

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
                      // Navigate to the PlaceOrderScreen and pass cartItems and finalPrice
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceOrderScreen(
                            cartItems: cartItems,
                            finalPrice: finalPrice,
                          ),
                        ),
                      );
                    },
                    child: const Text('Proceed to Place Order'),
                  ),
                ],
              ),
            ),
    );
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
        ],
      ),
    );
  }
}
