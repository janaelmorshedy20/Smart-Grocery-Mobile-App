import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/cart_screen.dart';
import 'package:smartgrocery/favoritelist.dart'; // Import the FavoriteListScreen
import 'package:smartgrocery/provider/cartprovider.dart';
import 'package:smartgrocery/provider/favoriteprovider.dart';
import 'models/Product.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  late Future<Product> _product;

  @override
  void initState() {
    super.initState();
    _product = getProductDetailsFromFirestore(widget.productId);
  }

  Future<Product> getProductDetailsFromFirestore(String productId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (doc.exists) {
        return Product.fromSnapshot(doc);
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      throw Exception("Error fetching product details: $e");
    }
  }

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Access snapshot data here inside builder function
              _product.then((product) {
                ref.read(favoriteProvider.notifier).addProduct(product);
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart, // Cart icon
              color: Colors.green, // Cart icon color
            ),
            onPressed: () {
              // Navigate to the Cart Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Product not found.'));
          }

          final product = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                // Product Title and Weight
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Price and Quantity Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${product.price}\EGP',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Product Details
                const Text(
                  'Product Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.detail,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Buy Now Button
                ElevatedButton(
<<<<<<< HEAD
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, // Sets the green color
    minimumSize: const Size(double.infinity, 50), // Button width fills parent, height is 50
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Matches the rounded corners
    ),
  ),
  onPressed: () {},
  child: const Text(
    'Buy Now', // Change the text to 'Login'
    style: TextStyle(
      color: Colors.white, // White text color
      fontSize: 16, // Adjust font size if needed
    ),
  ),
),
=======
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Add the product to the cart
                    ref.read(cartProvider.notifier).addProduct(product);
                  },
                  child: const Text('Buy Now'),
                ),

                // Go to Favorite List Button
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Navigate to the Favorite List Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavoriteListScreen()),
                    );
                  },
                  child: const Text('Go to Favorites'),
                ),
>>>>>>> b8fa655d0c9d20c25b0f132ff95437519994291f
              ],
            ),
          );
        },
      ),
    );
  }
}
