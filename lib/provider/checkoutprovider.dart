import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/models/Cart.dart';
import 'cartprovider.dart';

class CheckoutState {
  final double totalPrice;
  final bool isCheckoutSuccessful;
  final String checkoutMessage;

  CheckoutState({
    required this.totalPrice,
    required this.isCheckoutSuccessful,
    required this.checkoutMessage,
  });

  CheckoutState copyWith({
    double? totalPrice,
    bool? isCheckoutSuccessful,
    String? checkoutMessage,
  }) {
    return CheckoutState(
      totalPrice: totalPrice ?? this.totalPrice,
      isCheckoutSuccessful: isCheckoutSuccessful ?? this.isCheckoutSuccessful,
      checkoutMessage: checkoutMessage ?? this.checkoutMessage,
    );
  }
}

class CheckoutProvider extends StateNotifier<CheckoutState> {
  CheckoutProvider() : super(CheckoutState(totalPrice: 0.0, isCheckoutSuccessful: false, checkoutMessage: ''));

  // Calculate the total price of the cart items
  double calculateTotalPrice(List<CartItem> cartItems) {
    double totalPrice = 0.0;
    for (var item in cartItems) {
      totalPrice += item.product.price * item.quantity; // Multiply by quantity
    }
    return totalPrice;
  }

  // Start the checkout process
  Future<void> startCheckout(WidgetRef ref) async {
    final cartItems = ref.read(cartProvider); // Get the cart items from the cartProvider
    final totalPrice = calculateTotalPrice(cartItems);

    try {
      // Simulate a checkout process (e.g., network request)
      await Future.delayed(const Duration(seconds: 2));

      // On success, reset the cart and set the checkout state
      ref.read(cartProvider.notifier).clearCart(); // Clear the cart
      state = state.copyWith(
        totalPrice: totalPrice,
        isCheckoutSuccessful: true,
        checkoutMessage: 'Checkout successful! Your order is placed.',
      );
    } catch (e) {
      // On failure, set the checkout state to reflect the error
      state = state.copyWith(
        isCheckoutSuccessful: false,
        checkoutMessage: 'Checkout failed. Please try again.',
      );
    }
  }
}

// Define a global provider for Checkout
final checkoutProvider = StateNotifierProvider<CheckoutProvider, CheckoutState>((ref) {
  return CheckoutProvider();
});
