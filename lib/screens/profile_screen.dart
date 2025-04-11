import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_project/widgets/themed_scaffold.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../provider/background_provider.dart';
import '../widgets/buildGradient.dart';
import 'edit_profile_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Loading...';
  int coinBalance = 0;
  String? accessoryImage;
  String? equippedBackground;

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load profile data on screen start
  }

  // UI for showing simple info (icon + label in a row)
  Widget _buildInfoTile(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.amber),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Pick and upload a new profile image
  Future<void> uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user.uid}.jpg');
      await storageRef.putFile(file);

      // Get public URL for uploaded image
      final downloadUrl = await storageRef.getDownloadURL();

      // Save URL to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilePicture': downloadUrl});

      // Update Auth photo URL (optional)
      await user.updatePhotoURL(downloadUrl);

      setState(() {}); // Refresh UI
    } catch (e) {
      print('Upload failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  // Info tile for more detailed data (name/email/coins)
  Widget buildInfoTile(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Load Firestore shop item data by ID
  Future<Map<String, dynamic>?> getItemById(String id) async {
    final query = await FirebaseFirestore.instance
        .collection('shop_items')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  // Delete both Firebase Auth and Firestore data
  Future<void> deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    await user?.delete();

    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }

  // Load user data from Firestore + equipped background
  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final data = userDoc.data();
    final equipped = data?['equipped'];

    String? backgroundId;
    if (equipped is Map<String, dynamic> &&
        equipped.containsKey('background')) {
      backgroundId = equipped['background'];
    }

    if (backgroundId != null) {
      final backgroundData = await getItemById(backgroundId);
      final image = backgroundData?['image'];
      if (image != null) {
        Provider.of<BackgroundProvider>(context, listen: false)
            .setBackground(image);
      }
    }

    setState(() {
      userName = data?['username'] ?? user.email ?? "Guest";
      coinBalance = data?['coins'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgProvider = Provider.of<BackgroundProvider>(context);
    final backgroundImage = bgProvider.background;
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top curved background/header
          Stack(
            children: [
              ClipPath(
                clipper: CurvedClipper(),
                child: Container(
                  height: 220,
                  decoration: backgroundImage != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/backgrounds/$backgroundImage'),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                ),
              ),
              // Back arrow
              Positioned(
                top: 50,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Avatar and image upload button
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: photoUrl != null
                              ? NetworkImage(photoUrl)
                              : const AssetImage('assets/images/profile.png')
                                  as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: uploadProfilePicture,
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.deepPurple,
                              child: Icon(Icons.add,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Profile content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildInfoTile(Icons.monetization_on, "$coinBalance Coins"),
                  const SizedBox(height: 20),
                  buildInfoTile(Icons.account_box_rounded, userName),
                  buildInfoTile(Icons.email, user?.email ?? 'N/A'),
                  const SizedBox(height: 30),

                  // Action buttons
                  buildGradientButton(
                    context,
                    "Edit Profile",
                    Colors.deepPurple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditProfileScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildGradientButton(context, "Log Out", Colors.deepPurple,
                      () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/welcome', (route) => false);
                  }),
                  const SizedBox(height: 12),
                  buildGradientButton(context, "Delete Account", Colors.red,
                      () {
                    deleteAccount(context);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for curved top container
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
