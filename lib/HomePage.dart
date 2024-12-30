import 'package:flutter/material.dart';

import 'categoryScreen.dart';
import 'favoritelist.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = '';
  List<Map<String, dynamic>> _filteredPopularPacks = [];
  List<Map<String, dynamic>> _filteredNewItems = [];

  final List<Map<String, dynamic>> popularPacks = [
    {
      'name': 'Bundle Pack',
      'description': 'Onion, Oil, Salt',
      'price': '\$35',
      'oldPrice': '\$50.32',
      'image': 'assets/bundle-pack.jpg',
    },
    {
      'name': 'Medium Spice',
      'description': 'Onion, Oil, Salt',
      'price': '\$35',
      'oldPrice': '\$50.32',
      'image': 'assets/medium_spice.jpg',
    },
    {
      'name': 'Fruit Basket',
      'description': 'Apple, Banana, Orange',
      'price': '\$25',
      'oldPrice': '\$40.00',
      'image': 'assets/fruit-basket.webp',
    },
    {
      'name': 'Healthy Pack',
      'description': 'Lettuce, Tomato, Carrot',
      'price': '\$30',
      'oldPrice': '\$45.00',
      'image': 'assets/Healthy-pack.PNG',
    },
  ];

  final List<Map<String, dynamic>> newItems = [
    {
      'name': 'Perry\'s Ice Cream Banana',
      'description': '800 gm',
      'price': '\$13',
      'oldPrice': '\$15',
      'image': 'assets/icecream.jpeg',
    },
    {
      'name': 'Vanilla Ice Cream',
      'description': '500 gm',
      'price': '\$12',
      'oldPrice': '\$15',
      'image': 'assets/vanilla-icecream.jpg',
    },
    {
      'name': 'Lamar Milk',
      'description': '500 gm',
      'price': '\$14',
      'oldPrice': '\$18',
      'image': 'assets/milk.jpg',
    },
    {
      'name': 'Meat',
      'description': '250 gm',
      'price': '\$11',
      'oldPrice': '\$14',
      'image': 'assets/meat.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredPopularPacks = popularPacks;
    _filteredNewItems = newItems;
  }

  void _updateSearch(String value) {
    setState(() {
      _searchText = value;
      _filteredPopularPacks = popularPacks
          .where((item) =>
              item['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
      _filteredNewItems = newItems
          .where((item) =>
              item['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  int _selectedIndex = 0;  // Default selected index (Home)

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
        title: TextField(
          onChanged: _updateSearch,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular Packs Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Packs',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filteredPopularPacks.length,
                itemBuilder: (context, index) {
                  final pack = _filteredPopularPacks[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      width: 120,
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
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                            child: Image.asset(
                              pack['image'],
                              height: 80,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pack['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  pack['description'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      pack['price'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      pack['oldPrice'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // New Items Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Our New Item',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filteredNewItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredNewItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      width: 120,
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
                            child: Image.asset(
                              item['image'],
                              height: 80,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['description'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      item['price'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['oldPrice'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex, // Default selected index (Menu)
        onTap: (index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Navigate to the respective page when a bottom item is tapped
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoriteListScreen()),
        );
        break;
      default:
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
}
