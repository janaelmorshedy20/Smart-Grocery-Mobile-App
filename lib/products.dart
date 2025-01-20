
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  Stream<List<Map<String, dynamic>>> getProductsFromFirestore() {
    return FirebaseFirestore.instance
        .collection('products') // Collection name should match your Firestore setup
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // void deleteProduct(String productId) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('products').doc(productId).delete();
  //     print('Product deleted: $productId');
  //   } catch (e) {
  //     print('Error deleting product: $e');
  //   }
  // }


  void deleteProduct(BuildContext context, Map<String, dynamic> product) async {
  final productId = product['id'];

  // Temporarily delete the product from Firestore
  try {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();

    // Show a snackbar with undo action
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
        duration: const Duration(seconds: 4), // Duration before snackbar disappears
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
                  onDelete: () => deleteProduct(context, product),
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
          Text(
            '\$${product['price']}',
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