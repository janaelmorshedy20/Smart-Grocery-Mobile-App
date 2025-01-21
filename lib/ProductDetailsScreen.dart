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
  bool isFavorite = false;
  int quantity = 1;

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
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () {
              _product.then((product) {
                if (isFavorite) {
                  ref.read(favoriteProvider.notifier).removeProduct(product);
                } else {
                  ref.read(favoriteProvider.notifier).addProduct(product);
                }
                setState(() {
                  isFavorite = !isFavorite;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? '${product.name} added to favorites!'
                          : '${product.name} removed from favorites!',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.green,
            ),
            onPressed: () {
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
                // Display Product Image using product.imageUrl
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.imageUrl, // Display the product image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                Text(
                  '${product.price} EGP',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Product Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(product.detail,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Quantity:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () => setState(() => quantity =
                            (quantity > 1) ? quantity - 1 : quantity),
                        icon: const Icon(Icons.remove)),
                    Text('$quantity'),
                    IconButton(
                        onPressed: () => setState(() => quantity++),
                        icon: const Icon(Icons.add)),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    if (quantity <= product.quantity) {
                      ref
                          .read(cartProvider.notifier)
                          .addProduct(product, quantity);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${product.name} added to cart!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Not enough stock available'),
                          backgroundColor: Colors.red));
                    }
                  },
                  child: const Text('Add To Cart',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavoriteListScreen()),
                    );
                  },
                  child: const Text('Go to Favorites'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
