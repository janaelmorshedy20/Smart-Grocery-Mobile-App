import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/models/Product.dart';

class CartProvider extends StateNotifier<List<CartItem>> {
  CartProvider() : super([]);

  // Add product to the cart (with quantity)
  void addProduct(Product product, int quantity) {
    final existingProductIndex = state.indexWhere((item) => item.product.id == product.id);

    if (existingProductIndex == -1) {
      // If the product doesn't exist in the cart, add it with the selected quantity
      state = [...state, CartItem(product: product, quantity: quantity)];
    } else {
      // If the product is already in the cart, update the quantity
      final existingProduct = state[existingProductIndex];
      final newQuantity = existingProduct.quantity + quantity;
      if (newQuantity <= product.quantity) {
        existingProduct.quantity = newQuantity; // Update the quantity
        state = [...state]; // Trigger state change to notify listeners
      } else {
        // Show an error message if the quantity exceeds available stock
        // You can show a snackbar or handle it appropriately
      }
    }
  }

  // Remove product from the cart
  void removeProduct(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  // Update product quantity in the cart
  void updateQuantity(Product product, int quantity) {
    final existingProductIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingProductIndex != -1) {
      state[existingProductIndex].quantity = quantity;
      state = [...state]; // Trigger state change
    }
  }
}

// CartItem model to hold product and quantity
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

// Define a global provider for Cart
final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) {
  return CartProvider();
});
