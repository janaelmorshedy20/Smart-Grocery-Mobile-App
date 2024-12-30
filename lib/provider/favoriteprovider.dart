// favorite_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/models/Product.dart';

class FavoriteProvider extends StateNotifier<List<Product>> {
  FavoriteProvider() : super([]);

  // Add product to the favorites list
  void addProduct(Product product) {
    // Check if the product is already in the favorites list
    final existingProductIndex = state.indexWhere((item) => item.id == product.id);

    if (existingProductIndex == -1) {
      // If the product doesn't exist, add it to the favorites list
      state = [...state, product];
    }
  }

  // Remove product from the favorites list
  void removeProduct(Product product) {
    state = state.where((item) => item.id != product.id).toList();
  }
}

// Define a global provider for Favorites
final favoriteProvider = StateNotifierProvider<FavoriteProvider, List<Product>>((ref) {
  return FavoriteProvider();
});
