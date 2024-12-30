import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final List<Map<String, String>> dashboardItems = [
    {'title': 'Categories', 'value': '3'},
    {'title': 'Products', 'value': '9'},
    {'title': 'Users', 'value': '55'},
    {'title': 'Orders', 'value': '2'},
    {'title': 'Active Users', 'value': '34'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor:Colors.green,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green.shade100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Categories'),
                Text('Products'),
                Text('Orders'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: dashboardItems.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dashboardItems[index]['value']!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dashboardItems[index]['title']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
