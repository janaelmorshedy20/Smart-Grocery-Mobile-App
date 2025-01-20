// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smartgrocery/editprofile.dart';
// import 'package:smartgrocery/voucherscodes.dart';

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});

//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phonenumberController = TextEditingController();
//   bool _isLoading = false;
//   late String userId;

//   @override
//   void initState() {
//     super.initState();
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       userId = currentUser.uid;
//       _fetchUserProfile();
//     } else {
//       print('User not logged in');
//     }
//   }

//   void _fetchUserProfile() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       if (userDoc.exists) {
//         _nameController.text = userDoc['name'];
//         _emailController.text = userDoc['email'];
//         _phonenumberController.text = userDoc['phone'];
//       } else {
//         print('User profile not found');
//       }
//     } catch (e) {
//       print("Error fetching user profile: $e");
//     }

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.green,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Profile Header
//           Container(
//             padding: const EdgeInsets.all(15.0),
//             decoration: const BoxDecoration(
//               color: Colors.green,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Center(
//                     child: CircleAvatar(
//                   radius: 50.0, // Adjust the size as needed
//                   backgroundColor: Colors.grey[300],
//                   child: const Icon(
//                     Icons.person,
//                     size: 50.0, // Icon size
//                     color: Colors.white,
//                   ),
//                 )),
//                 const SizedBox(height: 10),
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Name: ${_nameController.text}',
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Email: ${_emailController.text}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Phone: ${_phonenumberController.text}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Horizontal Menu
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildMenuItem(Icons.shopping_cart, 'All Order'),
//                 _buildMenuItem(Icons.home, 'Address'),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Vertical Menu
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               children: [
//                 _buildListTile(Icons.person, 'Edit Profile', () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const EditProfileScreen(),
//                     ),
//                   );
//                 }),
//                 _buildListTile(Icons.settings, 'Setting', () {}),
//                 _buildListTile(Icons.payment, 'Payment', () {}),
//                 _buildListTile(Icons.card_giftcard, 'Vouchers', () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const VouchersPage(),
//                     ),
//                   );
//                 }),
//                 _buildListTile(Icons.logout, 'Logout', () {
//                   _logout(context);
//                 }),
                
//               ],
//             ),
//           ),
          
//         ],
//       ),
//     );
//   }

//   void _logout(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacementNamed(context, '/login2');
//     print('User Logged Out');
//   }

//   Widget _buildMenuItem(IconData icon, String label) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 30,
//           backgroundColor: Colors.green[100],
//           child: Icon(
//             icon,
//             color: Colors.green,
//             size: 30,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(label, style: const TextStyle(fontSize: 14)),
//       ],
//     );
//   }

//   Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.green),
//       title: Text(title),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgrocery/editprofile.dart';
import 'package:smartgrocery/vieworders.dart';
import 'package:smartgrocery/voucherscodes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phonenumberController = TextEditingController();
  bool _isLoading = false;
  late String userId;
  String? _allergyStatus; // Tracks the selected option: "Yes" or "No"

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      _fetchUserProfile();
    } else {
      print('User not logged in');
    }
  }

  void _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        _nameController.text = userDoc['name'];
        _emailController.text = userDoc['email'];
        _phonenumberController.text = userDoc['phone'];
      } else {
        print('User profile not found');
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAllergyStatus() async {
    if (_allergyStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an allergy status before saving.'),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('allergy_warnings')
          .doc(userId)
          .set({
        'userId': userId,
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phonenumberController.text,
        'allergyStatus': _allergyStatus,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Allergy status saved successfully.'),
        ),
      );
    } catch (e) {
      print("Error saving allergy status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving allergy status.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile' , style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(0.0),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Center(
                    child: CircleAvatar(
                  radius: 50.0, // Adjust the size as needed
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 50.0, // Icon size
                    color: Colors.white,
                  ),
                )),
                const SizedBox(height: 10),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${_nameController.text}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email: ${_emailController.text}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone: ${_phonenumberController.text}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
              ],
            ),
          ),

          const SizedBox(height: 16),


          // Vertical Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildListTile(Icons.person, 'Edit Profile', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                }),
                _buildListTile(Icons.shopping_cart, 'All Order',(){
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ViewOrderPage(),
                    ),
                   );
                }),
                _buildListTile(Icons.settings, 'Setting', () {}),
                _buildListTile(Icons.card_giftcard, 'Vouchers', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VouchersPage(),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            Icons.warning, // Icon for allergies or warning
            color: Colors.green, // Color of the icon
          ),
          const SizedBox(width: 8), // Space between the icon and the text
          const Text(
            'Do you have any allergic warnings?',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          const Text('No', style: TextStyle(fontSize: 15)),
          Switch(
            value: _allergyStatus == 'Yes',  // Check if the status is "Yes"
            onChanged: (bool value) {
              setState(() {
                _allergyStatus = value ? 'Yes' : 'No';  // Update status
              });
              // Save automatically when toggled
              _saveAllergyStatus();
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
          ),
          const Text('Yes', style: TextStyle(fontSize: 16)),
        ],
      ),
      if (_allergyStatus != null)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Selected: $_allergyStatus',
            style: const TextStyle(fontSize: 16, color: Colors.green),
          ),
        ),
    ],
  ),
),

 _buildListTile(Icons.logout, 'Logout', () {
                  _logout(context);
                }),

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login2');
    print('User Logged Out');
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

