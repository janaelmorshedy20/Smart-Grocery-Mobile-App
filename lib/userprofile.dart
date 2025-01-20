import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  late String userId;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      _fetchUserProfile(); // Fetch user profile after getting userId
    } else {
      // Handle the case when the user is not logged in
      print('User not logged in');
    }
  }

  void _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch user data from Firestore using the userId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')  // Assuming the users collection exists
          .doc(userId)  // Fetch user by userId
          .get();

      if (userDoc.exists) {
        // Check if the document exists and then update the fields
        _nameController.text = userDoc['name'];
        _emailController.text = userDoc['email'];
      } else {
        // Document does not exist
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
        title: const Text('User Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture (Icon)
            Center(
              child: CircleAvatar(
                radius: 50.0, // Adjust the size as needed
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 50.0, // Icon size
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Info
            _isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loading spinner when fetching data
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
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                _editProfile(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.edit, color: Colors.white), // Icon for the button
              label: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Past Orders Button
            ElevatedButton.icon(
              onPressed: () {
                _viewOrders(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.history, color: Colors.white), // Icon for the button
              label: const Text(
                'Past Orders',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () {
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.logout, color: Colors.white), // Icon for the button
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Edit Profile Function
  void _editProfile(BuildContext context) {
    Navigator.pushNamed(context, '/EditProfileScreen');
  }

  //  Orders Function
  void _viewOrders(BuildContext context) {
    Navigator.pushNamed(context, '/pastOrders');
  }

  // Logout Function
  void _logout(BuildContext context) async {
    // Clear session data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Log out the user from Firebase
    await FirebaseAuth.instance.signOut();

    // Redirect the user to the login screen
    Navigator.pushReplacementNamed(context, '/login2');
    print('User Logged Out');
  }
}
