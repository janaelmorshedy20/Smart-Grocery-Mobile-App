// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart'; // For capturing images
// import 'package:gallery_picker/gallery_picker.dart'; // For picking images from the gallery
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // For OCR

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: ShoppingListScreen(),
//     );
//   }
// }

// class ShoppingListScreen extends StatefulWidget {
//   @override
//   _ShoppingListScreenState createState() => _ShoppingListScreenState();
// }

// class _ShoppingListScreenState extends State<ShoppingListScreen> {
//   List<Map<String, dynamic>> shoppingList = [];
//   String selectedFrequency = 'None'; // Default frequency
//   String _recognizedText = 'Scanned text will appear here.'; // OCR result
//   //File? _selectedImage;

//   // Function to capture an image using the camera
//   // Future<void> _captureImage() async {
//   //   final cameras = await availableCameras();
//   //   final firstCamera = cameras.first;

//   //   final cameraController = CameraController(
//   //     firstCamera,
//   //     ResolutionPreset.medium,
//   //   );

//   //   try {
//   //     await cameraController.initialize();
//   //     final XFile imageFile = await cameraController.takePicture();
//   //     _processImage(File(imageFile.path));
//   //     cameraController.dispose();
//   //   } catch (e) {
//   //     setState(() {
//   //       _recognizedText = 'Error capturing image: $e';
//   //     });
//   //   }
//   // }

//   // Function to pick an image from the gallery
//   // Future<void> _pickImageFromGallery() async {
//   //   try {
//   //     final pickedFile = await GalleryPicker.pickSingleImage();

//   //     if (pickedFile != null) {
//   //       final File imageFile = File(pickedFile.path!);
//   //       _processImage(imageFile);
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       _recognizedText = 'Error selecting image: $e';
//   //     });
//   //   }
//   // }

//   // Function to process the selected or captured image
//   Future<void> _processImage() async {
//     // setState(() {
//     //   _selectedImage = imageFile;
//     // });

//     final inputImage = InputImage.fromFilePath("assets/Logical.jepg");
//     final textRecognizer = TextRecognizer();

//     try {
//       final RecognizedText recognizedText =
//           await textRecognizer.processImage(inputImage);
//       setState(() {
//         _recognizedText = recognizedText.text.isNotEmpty
//             ? recognizedText.text
//             : 'No text recognized.';
//       });
//     } catch (e) {
//       setState(() {
//         _recognizedText = 'Error during text recognition: $e';
//       });
//     } finally {
//       textRecognizer.close();
//     }
//   }

//   // Function to delete an item from the shopping list
//   void _deleteItem(int index) {
//     setState(() {
//       shoppingList.removeAt(index);
//     });
//   }

//   // Function to add all items to the cart
//   void _addAllToCart() {
//     setState(() {
//       shoppingList.addAll(shoppingList);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('All items added to cart!')),
//     );
//   }

//   // Function to open the frequency selection dialog
//   void _openFrequencySelectionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return FrequencySelectionDialog(
//           selectedFrequency: selectedFrequency,
//           onFrequencySelected: (String frequency) {
//             setState(() {
//               selectedFrequency = frequency;
//             });
//             Navigator.pop(context); // Close the dialog after selection
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Shopping List'),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // Display captured or selected image
//           // if (_selectedImage != null)
//           //   Padding(
//           //     padding: const EdgeInsets.all(16.0),
//           //     child: Image.file(_selectedImage!, fit: BoxFit.cover),
//           //   ),

//           // Display recognized text
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               _recognizedText,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),

//           // Shopping list
//           Expanded(
//             child: ListView.builder(
//               itemCount: shoppingList.length,
//               itemBuilder: (context, index) {
//                 final item = shoppingList[index];
//                 return ListTile(
//                   title: Text(item['title']),
//                   subtitle: Text('\$${item['price']}'),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => _deleteItem(index),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Add All to Cart Button
//           ElevatedButton(
//             onPressed: _addAllToCart,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Add All to Cart'),
//           ),

//           const SizedBox(height: 16),

//           // Display selected frequency
//           Text(
//             'Selected Frequency: $selectedFrequency',
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),

//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           // FloatingActionButton(
//           //   onPressed: _captureImage,
//           //   backgroundColor: Colors.blue,
//           //   child: const Icon(Icons.camera_alt),
//           // ),
//           // const SizedBox(height: 16),
//           // FloatingActionButton(
//           //   onPressed: _pickImageFromGallery,
//           //   backgroundColor: Colors.orange,
//           //   child: const Icon(Icons.photo_library),
//           // ),
//           const SizedBox(height: 16),
//           FloatingActionButton(
//             onPressed: _openFrequencySelectionDialog,
//             backgroundColor: Colors.green,
//             child: const Icon(Icons.schedule),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FrequencySelectionDialog extends StatefulWidget {
//   final String selectedFrequency;
//   final Function(String) onFrequencySelected;

//   const FrequencySelectionDialog({
//     required this.selectedFrequency,
//     required this.onFrequencySelected,
//   });

//   @override
//   _FrequencySelectionDialogState createState() =>
//       _FrequencySelectionDialogState();
// }

// class _FrequencySelectionDialogState extends State<FrequencySelectionDialog> {
//   late String tempFrequency;

//   @override
//   void initState() {
//     super.initState();
//     tempFrequency = widget.selectedFrequency;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Set Frequency'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           RadioListTile<String>(
//             title: const Text('Weekly'),
//             value: 'Weekly',
//             groupValue: tempFrequency,
//             onChanged: (value) {
//               setState(() {
//                 tempFrequency = value!;
//               });
//             },
//           ),
//           RadioListTile<String>(
//             title: const Text('Monthly'),
//             value: 'Monthly',
//             groupValue: tempFrequency,
//             onChanged: (value) {
//               setState(() {
//                 tempFrequency = value!;
//               });
//             },
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             widget.onFrequencySelected(tempFrequency);
//           },
//           child: const Text('Save'),
//         ),
//       ],
//     );
//   }
// }