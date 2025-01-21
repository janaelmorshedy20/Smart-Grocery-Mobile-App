import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/userprofile.dart';
import 'models/Category.dart';
import 'HomePage.dart';
import 'favoritelist.dart';
import 'productsScreen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // final categories = [
  //   {'name': 'Fruits and Vegetables', 'icon': Icons.local_florist},
  //   {'name': 'Bakery', 'icon': Icons.cake},
  //   {'name': 'Meat and Fish', 'icon': Icons.set_meal},
  //   {'name': 'Dairy and Eggs', 'icon': Icons.egg},
  //   {'name': 'Milk', 'icon': Icons.local_drink},
  //   {'name': 'Beverages', 'icon': Icons.local_cafe},
  //   {'name': 'Snacks', 'icon': Icons.fastfood},
  //   {'name': 'Medicine', 'icon': Icons.medical_services},
  //   {'name': 'Baby Care', 'icon': Icons.child_friendly},
  //   {'name': 'Beauty', 'icon': Icons.brush},
  //   {'name': 'Gym Equipment', 'icon': Icons.fitness_center},
  //   {'name': 'Gardening Tools', 'icon': Icons.grass},
  //   {'name': 'Pet Care', 'icon': Icons.pets},
  //   {'name': 'Others', 'icon': Icons.more_horiz},
  // ];

//  List<Category> _categories = [];

   Stream<List<Category>> getCategories() {
    return FirebaseFirestore.instance.collection('categories').snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList());
  }
  // Future<void> getCategories() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance.collection('categories').get();
  //     setState(() {
  //       _categories = snapshot.docs.map((doc) => Category.fromMap(doc.data())).toList();
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error loading categories: $e')),
  //     );
  //   }
  // }

  int selectedIndex = -1; // Default: No category selected
  int _selected = 1;  // Default selected index (Home)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Category' , style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: StreamBuilder<List<Category>>(
          stream: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading categories: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories available.'));
            }

            final categories = snapshot.data!;
          return GridView.builder(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsScreen(categoryId: category.id),),);
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Column(
                children: [
                  // CircleAvatar(
                  //   radius: 28,
                  //   backgroundColor:
                  //       isSelected ? Colors.green : Colors.grey[200],
                  //   child: Icon(
                  //     category['icon'] as IconData,
                  //     color: isSelected ? Colors.white : Colors.black,
                  //   ),
                  // ),
                  const SizedBox(height: 5),
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
          );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selected, // Default selected index (Menu)
        onTap: (index) {
    setState(() {
      _selected = index; // Update the selected index
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
              case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfileScreen()),
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