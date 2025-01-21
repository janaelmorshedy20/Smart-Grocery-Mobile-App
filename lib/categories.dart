import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'editCategory.dart';
import 'models/Category.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  Stream<List<Category>> getCategoriesFromFirestore() {
    // return FirebaseFirestore.instance.collection('categories').snapshots().map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());

    return FirebaseFirestore.instance.collection('categories').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList());
    }

  void deleteCategory(BuildContext context, Category category) async {
    final categoryId = category.id;
    // Temporarily delete the category from Firestore
    try {
      await FirebaseFirestore.instance.collection('categories').doc(categoryId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${category.name} deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              // Restore the category to Firestore
              await FirebaseFirestore.instance.collection('categories').doc(category.id).set(category.toMap());
              print('Undo: ${category.name} restored');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Undo: ${category.name} restored')),
              );
            },
          ),
          duration:const Duration(seconds: 4), // Duration before snackbar disappears
        ),
      );

      print('category deleted: $categoryId');
    } catch (e) {
      print('Error deleting category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting ${category.name}')),
      );
    }
  }

  void editCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // category grid
          Expanded(
          child:StreamBuilder<List<Category>>(
        stream: getCategoriesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categorys available'));
          }

          final categories = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                // final catg = Category.fromMap(category);
                return _buildCategoryCard(
                  context,
                  category: category,
                  onDelete: () => deleteCategory(context, category),
                  onEdit: () => editCategory(context, category),
                );
              },
            ),
          );
        },
      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required Category category,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (category.imageUrl != null && category.imageUrl.isNotEmpty)
            Image.network(
              category.imageUrl,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            )
          else
            const Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            category.name?? 'Unknown',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
