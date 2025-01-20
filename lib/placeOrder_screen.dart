import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/models/Cart.dart';
import 'package:smartgrocery/models/Order.dart' as OrderModel; // Alias the import
import 'package:smartgrocery/provider/cartprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlaceOrderScreen extends ConsumerStatefulWidget {
  final List<CartItem> cartItems;
  final double finalPrice;

  const PlaceOrderScreen({
    super.key,
    required this.cartItems,
    required this.finalPrice,
  });

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends ConsumerState<PlaceOrderScreen> {
  final _shippingAddressController = TextEditingController();
  String _customerName = '';
  String _phoneNumber = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Fetch user profile data (name and phone)
  void _fetchUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _customerName = userDoc['name'];
            _phoneNumber = userDoc['phone'];
            _isLoading = false;
          });
        } else {
          print('User profile not found');
        }
      } catch (e) {
        print("Error fetching user profile: $e");
      }
    } else {
      print('User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cartItems;

    // Calculate the total price dynamically
    double totalPrice = cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Details
                      const Text(
                        'Customer Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Display name as normal text
                      Text(
                        'Name: $_customerName',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      // Display phone number as normal text
                      Text(
                        'Phone: $_phoneNumber',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _shippingAddressController,
                        decoration: const InputDecoration(
                          labelText: 'Shipping Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Display Cart Items
                      const Text(
                        'Your Cart',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...cartItems.map((item) => _buildCartItem(item)).toList(),

                      const SizedBox(height: 20),

                      // Total Price
                      Text(
                        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 20),

                      // Place Order Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          _placeOrder(context, cartItems, totalPrice);
                        },
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Function to handle placing the order
  Future<void> _placeOrder(
      BuildContext context, List<CartItem> cartItems, double totalPrice) async {
    try {
      // Convert CartItem to Cart (since CartItem has quantity, we need to adjust for that)
      List<Cart> convertedItems = cartItems.map((item) {
        return Cart(
          id: item.product.id,
          name: item.product.name,
          price: item.product.price,
          totalprice: item.product.price * item.quantity, // Multiply by quantity
        );
      }).toList();

      final order = OrderModel.Order(
        // Use OrderModel.Order
        id: '', // Firestore will generate the ID
        items: convertedItems, // Use the converted Cart list
        totalPrice: totalPrice,
        status: 'Pending',
        orderDate: DateTime.now(),
        customerName: _customerName,
        shippingAddress: _shippingAddressController.text,
        phoneNumber: _phoneNumber,
      );

      // Save order to Firestore
      final orderRef = await FirebaseFirestore.instance
          .collection('orders')
          .add(order.toMap());

      // Clear the cart after placing the order
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(orderRef.id)
          .delete();

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

  // Build Cart Item widget
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
