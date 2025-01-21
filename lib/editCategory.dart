import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'models/Category.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category category;
  const EditCategoryScreen({super.key, required this.category});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();

  late String imageUrl;

  bool _isLoading = false;

  final Uuid uuid = const Uuid();

  File? file;

  GlobalKey<FormState> formState = GlobalKey();

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    fillCategoryFields();
  }


  // Pre-fill fields for editing
  late final Category category;

  void fillCategoryFields() {
    if (widget.category != null) {
      // Pre-fill fields for editing
      category = widget.category!;
      _nameController.text = category.name;
      imageUrl = category.imageUrl;
      print(imageUrl);
    }
  }

  Future<String> uploadImageToSupabase(String fileName) async {
    if (file == null) {
      print("couldn't upload the image");
      return '';
    }
    try {
      await Supabase.instance.client.storage.from('images') // 'images' is your Supabase storage bucket name
          .upload(fileName, file!).then((value) => print("Image upload successful"));

      final imageUrl = Supabase.instance.client.storage.from('images').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) file = File(image.path);
    setState(() {});
  }

  Future<void> saveCategory() async {
    if (!formState.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (file != null) {
      String fileName = _nameController.text;
      imageUrl = await uploadImageToSupabase(fileName);
    }
    if (imageUrl.isEmpty || imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a category image")),
      );
      return;
    }
    try {
      final category = Category(
        id: widget.category?.id ?? uuid.v4(),
        name: _nameController.text,
        imageUrl: imageUrl,
      );
      // Update existing category
      final docRef = FirebaseFirestore.instance.collection('categories').doc(category.id);
      await docRef.update(category.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving category: $e')),
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
          'Edit Category',
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
                            child: Image.file(
                              file!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image_not_supported,
                                size: 30, color: Colors.grey),
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
              const SizedBox(height: 20),
              const SizedBox(height: 30),
              // Add Category Button
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
                  onPressed: saveCategory,
                  child: const Text(
                    "Save Category",
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
