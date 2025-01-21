import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartgrocery/models/Cart.dart';
import 'package:smartgrocery/models/Order.dart'
    as OrderModel; // Alias the import
import 'package:smartgrocery/provider/cartprovider.dart';

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
  String _paymentMethod = 'Cash on Delivery'; // Default payment method

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
              : SingleChildScrollView(
                  // Make the body scrollable
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Details
                      const Text(
                        'Customer Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Name: $_customerName',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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

                      // Payment Method Selection
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Cash on Delivery'),
                              leading: Radio<String>(
                                value: 'Cash on Delivery',
                                groupValue: _paymentMethod,
                                onChanged: (String? value) {
                                  setState(() {
                                    _paymentMethod = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Credit Card'),
                              leading: Radio<String>(
                                value: 'Credit Card',
                                groupValue: _paymentMethod,
                                onChanged: (String? value) {
                                  setState(() {
                                    _paymentMethod = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
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
                        child: const Text(
                          'Place Order',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Function to handle placing the order
  Future<void> _placeOrder(
      BuildContext context, List<CartItem> cartItems, double totalPrice) async {
    if (_shippingAddressController.text.isEmpty) {
      // Show error if shipping address is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a shipping address.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      List<Cart> convertedItems = cartItems.map((item) {
        return Cart(
          id: item.product.id,
          name: item.product.name,
          price: item.product.price,
          totalprice:
              item.product.price * item.quantity, // Multiply by quantity
          quantity: item.quantity, // Added quantity
        );
      }).toList();

      final order = OrderModel.Order(
        id: '',
        items: convertedItems,
        totalPrice: totalPrice,
        status: 'Pending',
        orderDate: DateTime.now(),
        customerName: _customerName,
        shippingAddress: _shippingAddressController.text,
        phoneNumber: _phoneNumber,
        paymentMethod: _paymentMethod,
      );

      await FirebaseFirestore.instance.collection('orders').add(order.toMap());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Order Placed Successfully'),
            content: const Text(
              'Thank you for your order! We will process it soon.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacementNamed(
                      context, '/HomePage'); // Navigate to HomePage
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error placing the order. Please try again!'),
          backgroundColor: Colors.red,
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
          CircleAvatar(
            radius: 30,
            backgroundImage:
                NetworkImage(item.product.imageUrl), // Use product image URL
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
