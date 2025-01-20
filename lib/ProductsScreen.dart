import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ProductDetailsScreen.dart';
import 'models/Product.dart';

class ProductsScreen extends StatelessWidget {
  final String categoryId;

  const ProductsScreen({super.key, required this.categoryId});
  // const ProductsScreen({super.key, required this.categoryId});

  Stream<List<Product>> getItemsFromFirestore() {
    return FirebaseFirestore.instance
      .collection('products').where('category.id', isEqualTo: categoryId)
      .snapshots()
      .map((snapshot) =>snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());
  }

  // Future<Map<String, String>> getProductImagesFromSupabase() async {
  //   try {
  //     final response =
  //         await Supabase.instance.client.from('images/products/').select();
  //     print("Fetched images: $response");
  //     final images = response as List<dynamic>;
  //     return {for (var img in images) img['product_id']: img['image_url']};
  //   } catch (e) {
  //     print('Error fetching product images from Supabase: $e');
  //     return {};
  //   }
  // }

  // Stream<List<Product>> getCombinedProducts() async* {

  //   final firebaseProducts = await getItemsFromFirestore().first;

  //   final images = await getProductImagesFromSupabase();

  //   // await for (final products in firebaseProducts) {
  //   //   yield products.map((product) {
  //   //     // final Url = images[product.id] ?? 'default_image_url';
  //   //     // print(Url);
  //   //     // product.imageUrl = Url;
  //   //     // return product;
  //   //   }).toList();
  //   // }

  //   final combinedProducts = firebaseProducts.map((product) {
  //     final imageUrl = images[product.id] ?? 'default_image_url';
  //     return product.copyWith(imageUrl: imageUrl);
  //   }).toList();

  //   print("Combined products: $combinedProducts"); // Debug log
  //   yield combinedProducts;
  // }

//   Future<List<Map<String, dynamic>>> getProductImagesFromSupabase() async {
//   try {
//     final response = await Supabase.instance.client.from('product_images').select();

//     return List<Map<String, dynamic>>.from(response);
//   } catch (e) {
//     print('Error fetching product images from Supabase: $e');
//     return [];
//   }
// }

//   Stream<List<Map<String, dynamic>>> GetProducts(){
//   final firebaseProducts = getItemsFromFirestore();
//   final supabaseImages = await getProductImagesFromSupabase();

//   // Combine data by matching product IDs
//   return firebaseProducts.map((product) {
//     final image = supabaseImages.firstWhere(
//         (img) => img['product_id'] == product['id'],
//         orElse: () => {'image_url': 'default_image_url'});

//     return {
//       ...product,
//       'image_url': image['image_url'],
//     };
//   }).toList();
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Products",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Product>>(
          stream: getItemsFromFirestore(), // Get products from Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available.'));
            }

            final items = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ProductCard(product: item);
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(productId: product.id),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            product.imageUrl != ''? 
                  Image.network(
                    // "https://gralztxksbzwiprnipoj.supabase.co/storage/v1/object/public/images/products/test1",
                    product.imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
           // Replace this with an Image.asset or Image.network
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            // Text(
            //   product.weight,
            //   style: const TextStyle(fontSize: 12, color: Colors.grey),
            // ),
            Text(
              product.price.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_circle, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
