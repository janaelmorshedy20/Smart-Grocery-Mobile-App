import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You can replace these with dynamic data from your app (e.g., from Firebase)
    String userName = "John Doe";
    String userEmail = "johndoe@example.com";

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
            // User Info
            Text(
              'Name: $userName',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $userEmail',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Handle profile edit action
                _editProfile(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Past Orders Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the Past Orders screen
                _viewPastOrders(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Past Orders',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Handle logout action
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
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
    // Navigate to another screen where the user can edit their profile details
    // You can use a form or a text input dialog
    print('Edit Profile');
  }

  // Past Orders Function
  void _viewPastOrders(BuildContext context) {
    // Navigate to the Past Orders screen
    // You need to create a Past Orders screen and add it to the routes
    Navigator.pushNamed(
        context, '/pastOrders'); // Example of navigating to Past Orders page
  }

  // Logout Function
  void _logout(BuildContext context) {
    // Perform logout logic (clear data, redirect to login, etc.)
    print('User Logged Out');
  }
}
