import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgrocery/CategoryScreen.dart';
import 'package:smartgrocery/HomePage.dart';
import 'package:smartgrocery/editprofile.dart';
import 'package:smartgrocery/favoritelist.dart';
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
  int _selected = 3; // Set default selected index to Profile (index 3)

  @override
  void initState() {
    super.initState();
    _fetchAllergyStatus();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      _fetchUserProfile();
    } else {
      print('User not logged in');
    }
  }

  // Fetch user profile data (name and phone)
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

  // Fetch allergy status from SharedPreferences
  Future<void> _fetchAllergyStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _allergyStatus = prefs.getString('allergyStatus') ?? 'No'; // Default to 'No'
    });
  }

  // Save allergy status to SharedPreferences
  Future<void> _saveAllergyStatus() async {
    if (_allergyStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an allergy status before saving.'),
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('allergyStatus', _allergyStatus!); // Save to SharedPreferences

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
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
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
                _buildListTile(Icons.shopping_cart, 'All Orders', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewOrderPage(),
                    ),
                  );
                }),
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
                            Icons.warning,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
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
                            value: _allergyStatus == 'Yes',
                            onChanged: (bool value) {
                              setState(() {
                                _allergyStatus = value ? 'Yes' : 'No';
                              });
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selected, // Default selected index (Profile)
        onTap: (index) {
          setState(() {
            _selected = index; // Update the selected index
          });

          // Navigate to the respective page when a bottom item is tapped
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteListScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
              );
              break;
            default:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Save'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
