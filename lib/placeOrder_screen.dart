import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartgrocery/models/Cart.dart';
import 'package:smartgrocery/models/order.dart' as OrderModel; // Alias the import
import 'package:smartgrocery/provider/cartprovider.dart';
import 'package:intl/intl.dart'; // For formatting the date

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
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  String _customerName = '';
  String _phoneNumber = '';
  bool _isLoading = true;
  String _paymentMethod = 'Cash on Delivery'; // Default payment method
  String? _expirationDate;

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
              : SingleChildScrollView(  // Wrap the entire body inside SingleChildScrollView
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

                      // Payment Method Selection
                      const Text(
                        'Payment Method',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                      // Display Credit Card Fields if Credit Card is selected
                      if (_paymentMethod == 'Credit Card') ...[
                        const SizedBox(height: 20),
                        TextField(
                          controller: _cardNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Card Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _selectExpirationDate,
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: TextEditingController(text: _expirationDate),
                                    decoration: const InputDecoration(
                                      labelText: 'Expiration Date (MM/YY)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _cvvController,
                                decoration: const InputDecoration(
                                  labelText: 'CVV',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ],

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

    if (_paymentMethod == 'Credit Card' &&
        (_cardNumberController.text.isEmpty ||
            _expirationDate == null ||
            _cvvController.text.isEmpty)) {
      // Show error if credit card details are missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all credit card fields.'),
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
          totalprice: item.product.price * item.quantity,
          quantity: item.quantity,
        );
      }).toList();

      final order = OrderModel.Order(
        id: '',  // You can leave it empty for Firestore auto-generated ID
        items: convertedItems,
        totalPrice: totalPrice,
        status: 'Pending',
        orderDate: DateTime.now(),
        customerName: _customerName,
        shippingAddress: _shippingAddressController.text,
        phoneNumber: _phoneNumber,
        paymentMethod: _paymentMethod,
        cardNumber: _paymentMethod == 'Credit Card' ? _cardNumberController.text : null,
        expirationDate: _paymentMethod == 'Credit Card' ? _expirationDate : null,
        cvv: _paymentMethod == 'Credit Card' ? _cvvController.text : null,
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
                  Navigator.pushReplacementNamed(context, '/HomePage'); // Navigate to HomePage
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

  // Function to show a month-year picker for expiration date
  Future<void> _selectExpirationDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            hintColor: Colors.green,
            colorScheme: ColorScheme.light(primary: Colors.green),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _expirationDate = DateFormat('MM/yy').format(pickedDate);
      });
    }
  }
}
