// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);

//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   bool _isLoading = false;
//   late String userId;

//   @override
//   void initState() {
//     super.initState();
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       userId = currentUser.uid;
//       _fetchUserProfile(); // Fetch user profile after getting userId
//     } else {
//       // Handle the case when the user is not logged in
//       print('User not logged in');
//     }
//   }

//   void _fetchUserProfile() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Fetch user data from Firestore using the userId
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')  // Assuming the users collection exists
//           .doc(userId)  // Fetch user by userId
//           .get();

//       if (userDoc.exists) {
//         // Check if the document exists and then update the fields
//         _nameController.text = userDoc['name'];
//         _emailController.text = userDoc['email'];
//       } else {
//         // Document does not exist
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
//         title: const Text('User Profile', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//         elevation: 4,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Picture (Icon)
//             Center(
//               child: CircleAvatar(
//                 radius: 50.0, // Adjust the size as needed
//                 backgroundColor: Colors.grey[300],
//                 child: Icon(
//                   Icons.person,
//                   size: 50.0, // Icon size
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // User Info
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator()) // Show loading spinner when fetching data
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Name: ${_nameController.text}',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Email: ${_emailController.text}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),

//             // Edit Profile Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 _editProfile(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               icon: const Icon(Icons.edit, color: Colors.white), // Icon for the button
//               label: const Text(
//                 'Edit Profile',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Past Orders Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 _viewOrders(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               icon: const Icon(Icons.history, color: Colors.white), // Icon for the button
//               label: const Text(
//                 'Past Orders',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Logout Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 _logout(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               icon: const Icon(Icons.logout, color: Colors.white), // Icon for the button
//               label: const Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Edit Profile Function
//   void _editProfile(BuildContext context) {
//     Navigator.pushNamed(context, '/EditProfileScreen');
//   }

//   //  Orders Function
//   void _viewOrders(BuildContext context) {
//     Navigator.pushNamed(context, '/pastOrders');
//   }

//   // Logout Function
//   void _logout(BuildContext context) async {
//     // Clear session data
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     // Log out the user from Firebase
//     await FirebaseAuth.instance.signOut();

//     // Redirect the user to the login screen
//     Navigator.pushReplacementNamed(context, '/login2');
//     print('User Logged Out');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//         elevation: 4,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: CircleAvatar(
//                 radius: 50.0,
//                 backgroundColor: Colors.grey[300],
//                 child: const Icon(
//                   Icons.person,
//                   size: 50.0,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Name: ${_nameController.text}',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Email: ${_emailController.text}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//             ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditProfileScreen(), // Replace with your actual screen widget
//       ),
//     );
//   },
//   style: ElevatedButton.styleFrom(
//     backgroundColor: Colors.blue,
//     minimumSize: const Size(double.infinity, 50),
//   ),
//   child: const Text(
//     'Edit Profile',
//     style: TextStyle(color: Colors.white),
//   ),
// ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/pastOrders');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               icon: const Icon(Icons.history, color: Colors.white),
//               label: const Text('Past Orders', style: TextStyle(color: Colors.white)),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {
//                 _logout(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               icon: const Icon(Icons.logout, color: Colors.white),
//               label: const Text('Logout', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }

// class PastOrdersScreen extends StatelessWidget {
//   const PastOrdersScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Past Orders'),
//         backgroundColor: Colors.orange,
//       ),
//       body: const Center(
//         child: Text('Past Orders Screen Content'),
//       ),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         backgroundColor: Colors.red,
//       ),
//       body: const Center(
//         child: Text('Login Screen Content'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgrocery/editprofile.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
            padding: const EdgeInsets.all(15.0),
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

          // Horizontal Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuItem(Icons.shopping_cart, 'All Order'),
                _buildMenuItem(Icons.home, 'Address'),
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
                // _buildListTile(Icons.settings, 'Setting', () {}),
                _buildListTile(Icons.payment, 'Payment', () {}),
                _buildListTile(Icons.card_giftcard, 'Vouchers', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VouchersPage(),
                    ),
                  );
                }),
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

  Widget _buildMenuItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green[100],
          child: Icon(
            icon,
            color: Colors.green,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
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
