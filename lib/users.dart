import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/actionpage.dart';

class UsersTableScreen extends StatelessWidget {
  const UsersTableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Table'),
        centerTitle: true,
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
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
              ],
              rows: users.map((user) {
                final data = user.data() as Map<String, dynamic>;
                return DataRow(cells: [
                  DataCell(
                    GestureDetector(
                      onTap: () {
                        // Redirect to ActionPage when clicking on a row
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActionPage(userId: user.id),
                          ),
                        );
                      },
                      child: Text(data['name'] ?? 'N/A'),
                    ),
                  ),
                  DataCell(
                    GestureDetector(
                      onTap: () {
                        // Redirect to ActionPage when clicking on a row
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActionPage(userId: user.id),
                          ),
                        );
                      },
                      child: Text(data['email'] ?? 'N/A'),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
