import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgrocery/models/Product.dart';
import 'editProduct.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  Stream<List<Map<String, dynamic>>> getProductsFromFirestore() {
    return FirebaseFirestore.instance.collection('products') 
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
    }

  void deleteProduct(BuildContext context, Map<String, dynamic> product) async {
    final productId = product['id'];

    // Temporarily delete the product from Firestore
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['name']} deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              // Restore the product to Firestore
              await FirebaseFirestore.instance.collection('products').doc(productId).set(product);
              print('Undo: ${product['name']} restored');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Undo: ${product['name']} restored')),
              );
            },
          ),
          duration:const Duration(seconds: 5),
        ),
      );

      print('Product deleted: $productId');
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting ${product['name']}')),
      );
    }
  }

  void editProduct(BuildContext context, Product product) {
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
      body: Column(
        children: [
          // Product grid
          Expanded(
          child:StreamBuilder<List<Map<String, dynamic>>>(
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
                final prod = Product.fromMap(product);
                return _buildProductCard(
                  context,
                  product: product,
                  onDelete: () => deleteProduct(context, product),
                  onEdit: () => editProduct(context, prod),
                );
              },
            ),
          );
        },
      ),
          ),
        ],
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
          if (product['imageUrl'] != null && product['imageUrl'].isNotEmpty)
            Image.network(
              product['imageUrl'],
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            )
          else
            const Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            product['name'] ?? 'Unknown',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // if(product['onSale'])
          Text(
            '${product['price']} EGP',
            style: const TextStyle(fontSize: 12, color: Colors.green),
          ),
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
