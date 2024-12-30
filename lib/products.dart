import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  Stream<List<Map<String, dynamic>>> getProductsFromFirestore() {
    return FirebaseFirestore.instance
        .collection('products') // Collection name should match your Firestore setup
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()} as Map<String, dynamic>)
            .toList());
  }

  void deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      print('Product deleted: $productId');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void editProduct(BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getProductsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final products = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(
                  context,
                  product: product,
                  onDelete: () => deleteProduct(product['id']),
                  onEdit: () => editProduct(context, product),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context, {
    required Map<String, dynamic> product,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (product['image'] != null && product['image'].isNotEmpty)
            Image.network(
              product['image'],
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            )
          else
            const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            product['name'] ?? 'Unknown',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '\$${product['price']}',
            style: const TextStyle(fontSize: 14, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditProductScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Add your product editing logic here
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${product['name']}'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text('Edit screen for ${product['name']}'),
      ),
    );
  }
}