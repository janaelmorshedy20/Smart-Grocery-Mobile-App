import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/Product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
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
            onPressed: () {},
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
                    // image: DecorationImage(
                    //   image: NetworkImage(product.imageUrl), 
                    //   fit: BoxFit.cover,
                    // ),
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
                // Text('Weight: ${product.weight}', style: const TextStyle(color: Colors.grey)),
                // const SizedBox(height: 10),

                // Price and Quantity Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Text(
                        //   '\$${product.originalPrice}',
                        //   style: const TextStyle(
                        //     fontSize: 18,
                        //     decoration: TextDecoration.lineThrough,
                        //     color: Colors.grey,
                        //   ),
                        // ),
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) quantity--;
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$quantity'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add),
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

                // // Review Section
                // const Text(
                //   'Review',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 5),
                // Row(
                //   children: List.generate(5, (index) {
                //     return const Icon(Icons.star, color: Colors.amber);
                //   }),
                // ),
                // const Spacer(),

                // Buy Now Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {},
                  child: const Text('Buy Now'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}