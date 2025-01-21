//HomePage
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'categoryScreen.dart';
import 'favoritelist.dart';
import 'package:smartgrocery/userprofile.dart';
import 'filter_screen.dart';
import 'models/Product.dart';
import 'SearchResultsScreen.dart';
import 'ProductDetailsScreen.dart';
import 'OnSaleProductsScreen.dart';
import 'RecentlyAddedScreen.dart';

String supabaseBaseUrl = "https://gralztkxbszwirpnpjop.supabase.co/storage/v1/object/public";
// Function to construct the full Supabase image URL
String getImageUrl(String imagePath) {
  return "$supabaseBaseUrl/images/$imagePath"; 
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = '';
  bool _isSearching = false;
  List<Product> allProducts = [];
  List<Product> searchResults = [];
  List<Product> onSaleProducts = [];
  List<Product> recentlyAddedProducts = []; // Store recently added products


  /* final List<Map<String, dynamic>> newItems = [
    {
      'name': 'Paradise Ice Cream Chocolate',
      'description': '800 gm',
      'price': '\$13.0',
      'oldPrice': '\$15.0',
      'image': 'assets/icecream.jpeg',
    },
    {
      'name': 'Vanilla Ice Cream',
      'description': '500 gm',
      'price': '\$12.0',
      'oldPrice': '\$15.0',
      'image': 'assets/vanilla_icecream.jpg',
    },
    {
      'name': 'Lamar Milk',
      'description': '500 gm',
      'price': '\$14.0',
      'oldPrice': '\$18.0',
      'image': 'assets/milk.jpg',
    },
    {
      'name': 'Meat',
      'description': '250 gm',
      'price': '\$11.0',
      'oldPrice': '\$14.0',
      'image': 'assets/meat.jpg',
    },
  ]; */

  @override
void initState() {
  super.initState();
  fetchProducts();
  fetchOnSaleProducts();
  fetchRecentlyAddedProducts();
}


   Future<void> fetchProducts() async {
    var querySnapshot = await FirebaseFirestore.instance.collection('products').get();
    var products = querySnapshot.docs.map((doc) {
    var data = doc.data();
    print("Product: ${data['name']}, Image URL: ${data['imageUrl']}"); // Debugging
    return Product.fromSnapshot(doc);
    }).toList();

    setState(() {
    allProducts = products;
      });
    }

  Future<void> fetchOnSaleProducts() async {
    var querySnapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('isOnSale', isEqualTo: true) // Get only on-sale products
      .get();

    var products = querySnapshot.docs.map((doc) {
    var data = doc.data();
    print("On Sale Product: ${data['name']}, Image URL: ${data['imageUrl']}"); // Debugging
    return Product.fromSnapshot(doc);
  }).toList();

  setState(() {
    onSaleProducts = products; // Store the on-sale products
  });
}

Future<void> fetchRecentlyAddedProducts() async {
  var querySnapshot = await FirebaseFirestore.instance
      .collection('products')
      .orderBy('createdAt', descending: true) // Fetch latest products first
      .limit(10) // Fetch only the last 10 added products
      .get();

  var products = querySnapshot.docs.map((doc) {
    var data = doc.data();
    print("Recently Added Product: ${data['name']}, Created At: ${data['createdAt']}"); // Debugging
    return Product.fromSnapshot(doc);
  }).toList();

  setState(() {
    recentlyAddedProducts = products; // Store the recently added products
  });
}



  void _updateSearch(String value) {
  setState(() {
    _searchText = value;
    searchResults = allProducts
        .where((product) => product.name.toLowerCase().startsWith(value.toLowerCase()))
        .toList();
  });
}

  void _applyFilters() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilterScreen(),
      ),
    );

    if (result != null) {
      double minPrice = (result['minPrice'] as num).toDouble();
      double maxPrice = (result['maxPrice'] as num).toDouble();
      List<String> selectedCategories =
          List<String>.from(result['categories'] ?? []);

      List<Product> filteredProducts = allProducts.where((product) {
        return product.price >= minPrice &&
            product.price <= maxPrice &&
            (selectedCategories.isEmpty ||
                selectedCategories.contains(product.category.name));
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SearchResultsScreen(allProducts: filteredProducts),
        ),
      );
    }
  }

  int _selectedIndex = 0;
  // List of pages to navigate to
  // final List<Widget> _pages = [
  //   const HomePage(),
  //   const CategoryScreen(),
  //   const FavoriteListScreen(),
  //   //ProfilePage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: !_isSearching
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
          children: const [
            Icon(
              Icons.shopping_cart,
              size: 35,
              color: Colors.green,
            ),
            SizedBox(width: 10),
            Text('E-Grocery',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      : TextField(
          onChanged: _updateSearch,
          decoration: InputDecoration(
            hintText: 'Search...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchText = '';
                  searchResults.clear();
                });
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _applyFilters,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSearching && _searchText.isNotEmpty)
              SizedBox(
                height: 250,
                child: searchResults.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final product = searchResults[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 3,
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
                                    return Image.asset('assets/placeholder.png', width: 80, height: 80, fit: BoxFit.cover);
                                  },
                                ),
                              ),
                              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.isOnSale) ...[
                                    Text(
                                      '${product.newPrice.toStringAsFixed(2)} EGP',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                    Text(
                                      '${product.price.toStringAsFixed(2)} EGP',
                                      style: const TextStyle(fontSize: 14, color: Colors.red, decoration: TextDecoration.lineThrough),
                                    ),
                                  ] else ...[
                                    Text(
                                      '${product.price.toStringAsFixed(2)} EGP',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                  ],
                                ],
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
                          );
                        },
                      )
                    : const Center(child: Text('No matching products', style: TextStyle(fontSize: 16))),
),

            // Banner Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/banner.PNG'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(right: 15.0, top: 10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Order your Daily Groceries\n#Free Delivery',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 7.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      // On Sale Section
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('On Sale',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnSaleProductsScreen(onSaleProducts: onSaleProducts),
                  ),
                );
              },
              child: const Text('View All', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: onSaleProducts.length,
          itemBuilder: (context, index) {
            final product = onSaleProducts[index];
            return buildItemCard(product);
          },
        ),
      ),
      // Recently Added Section
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recently Added',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecentlyAddedScreen(
                        recentlyAddedProducts: recentlyAddedProducts,
                      ),
                    ),
                  );
                },
                child: const Text('View All', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentlyAddedProducts.length, 
            itemBuilder: (context, index) {
              final product = recentlyAddedProducts[index];
              return buildItemCard(product);
            },
          ),
        ),

    ],
  ),
),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
              break;
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen()));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteListScreen()));
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                      builder: (context) => const UserProfileScreen()));
              break;
              
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Save'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Move this function OUTSIDE of buildItemCard
/* Widget buildItemCardFromMap(Map<String, dynamic> item) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(item['image'], height: 90, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(item['description'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(item['price'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(width: 8),
                    Text(item['oldPrice'], style: const TextStyle(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
} */

// This function stays the same but is now correctly structured
Widget buildItemCard(Product product) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(productId: product.id),
            ),
          );
        },
        child: Container(
          width: 130,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Load image from Firestore
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        height: 115,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/placeholder.png', height: 90, width: double.infinity, fit: BoxFit.cover);
                        },
                      )
                    : Image.asset('assets/placeholder.png', height: 90, width: double.infinity, fit: BoxFit.cover),
              ),
              // Product Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.detail,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.isOnSale) ...[
                          Text(
                            '${product.newPrice.toStringAsFixed(2)} EGP',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '${product.price.toStringAsFixed(2)} EGP',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ] else ...[
                          Text(
                            '${product.price.toStringAsFixed(2)} EGP',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}


