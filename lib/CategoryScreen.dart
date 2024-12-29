import 'package:flutter/material.dart';

import 'productsScreen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final categories = [
    {'name': 'Fruits and Vegetables', 'icon': Icons.local_florist},
    {'name': 'Bakery', 'icon': Icons.cake},
    {'name': 'Meat and Fish', 'icon': Icons.set_meal},
    {'name': 'Dairy and Eggs', 'icon': Icons.egg},
    {'name': 'Milk', 'icon': Icons.local_drink},
    {'name': 'Beverages', 'icon': Icons.local_cafe},
    {'name': 'Snacks', 'icon': Icons.fastfood},
    {'name': 'Medicine', 'icon': Icons.medical_services},
    {'name': 'Baby Care', 'icon': Icons.child_friendly},
    {'name': 'Beauty', 'icon': Icons.brush},
    {'name': 'Gym Equipment', 'icon': Icons.fitness_center},
    {'name': 'Gardening Tools', 'icon': Icons.grass},
    {'name': 'Pet Care', 'icon': Icons.pets},
    {'name': 'Others', 'icon': Icons.more_horiz},
  ];

  int selectedIndex = -1; // Default: No category selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Category'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsScreen(),),);
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        isSelected ? Colors.green : Colors.grey[200],
                    child: Icon(
                      category['icon'] as IconData,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category['name'] as String,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Default selected index (Menu)
        onTap: (index) {
          // Handle navigation here
          print('Tapped on index $index');
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