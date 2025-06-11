import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/login_provider.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String uid;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: const Text(" Profile", style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.purple, height: 2),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<LoginProvider>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage('assets/profile.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black87,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledInput(
                        label: "Full Name",
                        icon: Icons.person,
                        controller: value.nameController,
                        enabled: value.isEditing,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        value.isEditing ? Icons.cancel : Icons.edit,
                        color: Colors.deepOrange,
                      ),
                      onPressed: () => value.toggleEditMode(),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                _buildLabeledInput(
                  label: "Phone Number",
                  icon: Icons.phone,
                  controller: value.phoneController,
                  enabled: false,
                ),
                const SizedBox(height: 30),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (value.isEditing)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () async {
                          final updatedName = value.nameController.text.trim();
                          final prefs = await SharedPreferences.getInstance();
                          final phone = prefs.getString('user_phone');

                          if (phone != null) {
                            await FirebaseFirestore.instance
                                .collection('boys')
                                .doc(uid)
                                .update({'name': updatedName});

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profile updated successfully", style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.blue,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            value.toggleEditMode();
                          }
                        },
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text("Save", style: TextStyle(color: Colors.white)),
                      ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text("Logout", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}

  Widget _buildLabeledInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool enabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.deepOrange),
              suffixIcon: const Icon(Icons.check_circle, color: Colors.black),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text("Cancel"),
          ),
          Consumer<LoginProvider>(builder: (context, value, child) {
            return TextButton(
              onPressed: () async {
                value.logout();
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            );
          }),
        ],
      ),
    );
  }

