import 'package:flutter/material.dart';
import 'models/Product.dart';
import 'ProductDetailsScreen.dart';

class RecentlyAddedScreen extends StatelessWidget {
  final List<Product> recentlyAddedProducts;

  const RecentlyAddedScreen({super.key, required this.recentlyAddedProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Added Products'),
        backgroundColor: Colors.green, // Match theme
      ),
      body: recentlyAddedProducts.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recentlyAddedProducts.length,
              itemBuilder: (context, index) {
                final product = recentlyAddedProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/placeholder.png',
                              width: 80, height: 80, fit: BoxFit.cover);
                        },
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.isOnSale) ...[
                          Text(
                            '${product.newPrice.toStringAsFixed(2)} EGP',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Text(
                            '${product.price.toStringAsFixed(2)} EGP',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ] else ...[
                          Text(
                            '${product.price.toStringAsFixed(2)} EGP',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(productId: product.id),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No recently added products!',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
    );
  }
}
