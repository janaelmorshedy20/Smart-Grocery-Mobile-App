import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartgrocery/usersorderforadmin.dart';

class UsersTableScreen extends StatelessWidget {
  const UsersTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Table'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.grey, size: 50),
                  SizedBox(height: 10),
                  Text('No users found.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          final users = snapshot.data!.docs;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Users List',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Make the ListView scrollable
                ListView.builder(
                  shrinkWrap: true, // Ensures that the ListView takes up only the necessary space
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling within the ListView itself
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final data = users[index].data() as Map<String, dynamic>;
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(data['name'][0].toUpperCase(), style: TextStyle(color: Colors.white)),
                        ),
                        title: Text(
                          data['name'] ?? 'N/A',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data['email'] ?? 'N/A', style: TextStyle(color: Colors.grey)),
                        onTap: () {
                          // Navigate to the UserOrdersPage passing the user name
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserOrdersPage(userName: data['name']),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
