import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/Product.dart'; 
import '/ProductDetailsScreen.dart'; 

class OnSaleProductsScreen extends StatelessWidget {
  final List<Product> onSaleProducts;

  const OnSaleProductsScreen({Key? key, required this.onSaleProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("On Sale Products"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: onSaleProducts.length,
        itemBuilder: (context, index) {
          final product = onSaleProducts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl, 
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/placeholder.png', width: 60, height: 60, fit: BoxFit.cover);
                  },
                ),
              ),
              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${product.newPrice.toStringAsFixed(2)} EGP', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                  Text('${product.price.toStringAsFixed(2)} EGP', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red, decoration: TextDecoration.lineThrough)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailsScreen(productId: product.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
