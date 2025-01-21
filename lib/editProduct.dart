import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'models/Product.dart';
import 'models/Category.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _newPriceController = TextEditingController();
  final TextEditingController _productionDateController =
      TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  Category? _selectedCategory;

  // DateTime? _productionDate;
  // DateTime? _expireDate;
  bool _isOnSale = false;
  bool _isAllergyCausing = false;
  late String imageUrl;

  bool _isLoading = false;

  final formatter = DateFormat('yyyy-MM-dd');
  final Uuid uuid = const Uuid();

  File? file;

  GlobalKey<FormState> formState = GlobalKey();

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
    fillproductFields();
  }

  Future<void> _getCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      setState(() {
        _categories =
            snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading categories: $e')),
      );
    }
  }

  // Pre-fill fields for editing
  late final Product product;

  void fillproductFields() {
    if (widget.product != null) {
      // Pre-fill fields for editing
      product = widget.product!;
      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _detailController.text = product.detail;
      _weightController.text = product.weight.toString();
      _quantityController.text = product.quantity.toString();
      _productionDateController.text = formatter.format(product.productionDate);
      _expireDateController.text = formatter.format(product.expireDate);
      _isOnSale = product.isOnSale;
      _newPriceController.text = product.newPrice.toString();
      _isAllergyCausing = product.isAllergenic;
      _selectedCategory = product.category; // Start with no new image
      imageUrl = product.imageUrl;
      print(imageUrl);
    }
  }

  Future<String> uploadImageToSupabase(String fileName) async {
    if (file == null) {
      print("couldn't upload the image");
      return '';
    }
    try {
      await Supabase.instance.client.storage
          .from('images') // 'images' is your Supabase storage bucket name
          .upload(fileName, file!)
          .then((value) => print("Image upload successful"));

      final imageUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(fileName);
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

  Future<void> saveProduct() async {
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
        const SnackBar(content: Text("Please provide a product image")),
      );
      return;
    }
    try {
      final product = Product(
        id: widget.product?.id ?? uuid.v4(),
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        detail: _detailController.text,
        category: _selectedCategory!,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        productionDate:
            DateTime.tryParse(_productionDateController.text) ?? DateTime.now(),
        expireDate:
            DateTime.tryParse(_expireDateController.text) ?? DateTime.now(),
        isOnSale: _isOnSale,
        newPrice:
            _isOnSale ? double.tryParse(_newPriceController.text) ?? 0.0 : 0.0,
        isAllergenic: _isAllergyCausing,
        createdAt: widget.product?.createdAt ?? Timestamp.now(),
        imageUrl: imageUrl,
      );
      // Update existing product
      final docRef =
          FirebaseFirestore.instance.collection('products').doc(product.id);
      await docRef.update(product.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving product: $e')),
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
          'Edit Product',
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
                "Upload the Product Picture",
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
                            borderRadius: BorderRadius.circular(
                                16), // To match the container's border radius
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
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please enter the product name";
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  suffixText: 'EGP',
                  labelText: "Product Price",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please enter the product price";
                  if (double.parse(value) <= 0)
                    return "Please enter a valid price";
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _detailController,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Product Detail",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // const Text(
              //   "Select Category",
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 10),
              // DropdownButtonHideUnderline(
              //   child: DropdownButton<Category>(
              //     value: _selectedCategory,
              //     items: _categories
              //         .map(
              //           (category) => DropdownMenuItem(
              //             value: category,
              //             child: Text(category.name),
              //           ),
              //         )
              //         .toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         _selectedCategory = value;
              //       });
              //     },
              //     dropdownColor: Colors.white,
              //     hint: const Text("Select Category"),
              //     iconSize: 36,
              //     icon: const Icon(
              //       Icons.arrow_drop_down,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    suffixText: 'g',
                    labelText: "Weight",
                    border: OutlineInputBorder()),
                // decoration: const InputDecoration(suffixText: 'Liter', labelText: "Weight", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please enter the product Weight";
                  if (double.parse(value) <= 0)
                    return "Please enter a valid Weight";
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Quantity", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please enter the product quantity";
                  if (int.parse(value) <= 0)
                    return "Please enter a valid quantity";
                },
              ),
              const SizedBox(height: 20),

              // Production Date
              TextFormField(
                controller: _productionDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Production Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _productionDateController.text =
                          formatter.format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a production date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Expire Date
              TextFormField(
                controller: _expireDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Expire Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _expireDateController.text = formatter.format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select an expire date";
                  }
                  if (_productionDateController.text.isNotEmpty &&
                      DateTime.parse(value).isBefore(
                          DateTime.parse(_productionDateController.text))) {
                    return "Expire date cannot be earlier than production date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Is On Sale?",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: _isOnSale,
                    onChanged: (value) {
                      setState(() {
                        _isOnSale = value!;
                      });
                    },
                  ),
                  RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: _isOnSale,
                    onChanged: (value) {
                      setState(() {
                        _isOnSale = value!;
                      });
                    },
                  ),
                  if (_isOnSale)
                    TextFormField(
                      controller: _newPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        suffixText: ' EGP',
                        labelText: "New Price",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (_isOnSale) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the new price";
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0 ||
                              double.parse(value) >=
                                  double.parse(_priceController.text)) {
                            return "Please enter a valid discounted price";
                          }
                        }
                        return null;
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Causes Allergy?",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: _isAllergyCausing,
                    onChanged: (value) {
                      setState(() {
                        _isAllergyCausing = value!;
                      });
                    },
                  ),
                  RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: _isAllergyCausing,
                    onChanged: (value) {
                      setState(() {
                        _isAllergyCausing = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Add Product Button
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
                  onPressed: saveProduct,
                  child: const Text(
                    "Save Product",
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
