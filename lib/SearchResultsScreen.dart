import 'package:flutter/material.dart';
import 'models/Product.dart';
import 'ProductDetailsScreen.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<Product> allProducts;

  const SearchResultsScreen({super.key, required this.allProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filtered Products')),
      body: ListView.builder(
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          final product = allProducts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(productId: product.id),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
