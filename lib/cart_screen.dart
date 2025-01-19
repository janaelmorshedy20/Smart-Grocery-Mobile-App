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

    // Calculate the total price dynamically based on the product prices fetched from Firestore
    double totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.price);
    double discount = 12.25; // Sample discount, can be dynamic
    double finalPrice = totalPrice - discount;

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
                      .map((product) => _buildCartItem(product, ref))
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
                            hintText: 'Entry Voucher Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
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
                  Text('Discount: \$${discount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough)),
                  const SizedBox(height: 10),
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
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Save'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _checkout(
      BuildContext context, List<Product> cartItems, double finalPrice) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Cart newCart = Cart(
      id: '',
      name: 'User Cart', // You can customize this as needed
      price: finalPrice,
      totalprice: finalPrice,
    );

    // Create a reference to the Firestore 'carts' collection
    final cartRef = firestore.collection('carts').doc();

    // Prepare the data for saving
    List<Map<String, dynamic>> productData = cartItems.map((product) {
      return {
        'name': product.name,
        'price': product.price,
      };
    }).toList();

    // Prepare the data to be saved, including the products and total price
    final cartData = {
      'totalprice': finalPrice,
      'products': productData,
    };

    // Save the cart data to Firestore
    cartRef.set(cartData).then((_) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart saved successfully!'),
        ),
      );
      // You can navigate the user to a different page (e.g., Order Confirmation) here
    }).catchError((error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  // Pass ref to _buildCartItem to allow access to the provider
  Widget _buildCartItem(Product product, WidgetRef ref) {
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
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(product.detail,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text('${product.price} EGP',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              ref.read(cartProvider.notifier).removeProduct(product);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
