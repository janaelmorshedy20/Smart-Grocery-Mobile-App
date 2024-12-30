import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/Product.dart';
import 'models/Category.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  Category? _selectedCategory;
  bool _isLoading = false;

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<void> _getCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      setState(() {
        _categories = snapshot.docs
            .map((doc) => Category.fromMap(
                doc.data())) // Assuming Category has a fromMap method
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading categories: $e')),
      );
    }
  }

  // Method to add product to Firestore
  Future<void> addProductToFirebase() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

// Price validation: check if it's a positive number
    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The price should be a positive number")),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
      return;
    }
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the product name")),
      );
      return;
    }

    if (_detailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter product details")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = Product(
        id: '', // You can use an auto-generated ID or leave it blank for Firestore to generate one
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        detail: _detailController.text,
        category: _selectedCategory!, // Category selected by the user
        // createdAt: Timestamp.now(),
      );

      // Add product data to Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );

      // Clear fields after successful addition
      _nameController.clear();
      _priceController.clear();
      _detailController.clear();
      setState(() {
        _selectedCategory = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Upload the Product Picture",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // Add your image picker logic here
              print("Image upload tapped");
            },
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              suffixText: 'EGP',
              labelText: "Product Price",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _detailController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "Product Detail",
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Select Category",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              value: _selectedCategory,
              items: _categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              dropdownColor: Colors.white,
              hint: const Text("Select Category"),
              iconSize: 36,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Add Product Button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: addProductToFirebase,
              child: const Text(
                "Add Product",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
