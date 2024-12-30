import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/models/Product.dart';
class CartProvider extends StateNotifier<List<Product>> {
  CartProvider() : super([]);

  // Add product to the cart (only if it's not already there)
  void addProduct(Product product) {
    // Check if the product is already in the cart
    final existingProductIndex = state.indexWhere((item) => item.id == product.id);

    if (existingProductIndex == -1) {
      // If the product doesn't exist, add it to the cart
      state = [...state, product];
    }
  }

  // Remove product from the cart
  void removeProduct(Product product) {
    state = state.where((item) => item.id != product.id).toList();
  }
}

// Define a global provider for Cart
final cartProvider = StateNotifierProvider<CartProvider, List<Product>>((ref) {
  return CartProvider();
});
