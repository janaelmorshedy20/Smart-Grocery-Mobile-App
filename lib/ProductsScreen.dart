import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProductDetailsScreen.dart';
import 'models/Product.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});


  Stream<List<Product>> getItemsFromFirestore() {
    return FirebaseFirestore.instance
        .collection('products') 
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromSnapshot(doc))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          "Products",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Product>>(
          stream: getItemsFromFirestore(), // Get products from Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available.'));
            }

            final items = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ProductCard(product: item);
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(productId: product.id),),);
        },
      child:Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Placeholder(
            fallbackHeight: 80,
            fallbackWidth: 80,
          ), // Replace this with an Image.asset or Image.network
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          // Text(
          //   product.weight,
          //   style: const TextStyle(fontSize: 12, color: Colors.grey),
          // ),
          Text(
            product.price.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle, color: Colors.green),
          ),
        ],
      ),
      ),
    );
  }
}