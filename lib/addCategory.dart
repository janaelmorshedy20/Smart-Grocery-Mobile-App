import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'models/Category.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;

  final Uuid uuid = const Uuid();

  Future<void> addCategory() async {

    if (!formState.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final category = Category(
        id: uuid.v4(),
        name: _nameController.text,
        // createdAt: Timestamp.now(),
      );

      // Add category data to Firestore
      await FirebaseFirestore.instance
          .collection('categories')
          .add(category.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category added successfully!')),
      );

      formState.currentState!.reset();
      setState(() {
        _nameController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding category: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  File? file;

  getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) file = File(image!.path);
    setState(() {});
  }

  GlobalKey<FormState> formState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add category',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formState,
          child: ListView(
            children: [
              const Text(
                "Upload the Category Picture",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: file != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16), // To match the container's border radius
                            child: Image.file(file!, width: 120, height: 120, fit: BoxFit.cover,),
                          )
                        : const Icon(Icons.photo_camera, color: Colors.grey,),
                  ),
                ),
                onTap: () async {
                  await getImage();
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please enter the category name";
                },
              ),
              const SizedBox(height: 30),
              // Add category Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: addCategory,
                  child: const Text(
                    "Add Category",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
