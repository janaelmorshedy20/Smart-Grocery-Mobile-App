import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/ProductDetailsScreen.dart';
import 'package:smartgrocery/models/Product.dart'; // Import your Product model
import 'package:smartgrocery/provider/favoriteprovider.dart'; // Import the favorite provider

class FavoriteListScreen extends ConsumerWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteItems = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        elevation: 4,
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: Text('No favorites yet', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...favoriteItems.map((product) => _buildFavoriteItem(product, ref)).toList(),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(Product product, WidgetRef ref) {
    return Dismissible(
      key: Key(product.id), // Unique key for each product
      direction: DismissDirection.endToStart, // Swipe from right to left
      onDismissed: (direction) {
        ref.read(favoriteProvider.notifier).removeProduct(product); // Remove from favorites

        // After the item is removed, navigate back and refresh the ProductDetailsScreen
        Navigator.pop(ref.context); // Pop the current screen (FavoriteListScreen)
        Navigator.pushReplacement(
          ref.context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(productId: product.id),
          ),
        );

        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('${product.name} removed from favorites!'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red, // Background color for the swipe
          borderRadius: BorderRadius.circular(16.0),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 120),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8.0, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/product.png'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.detail,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${product.price} EGP',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
