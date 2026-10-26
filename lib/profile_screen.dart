import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'userinformation.dart'; // Make sure this path is correct

class ProfileScreen extends StatelessWidget {
  final String name;
  final double calories;
  final double protein;
  final double water;
  final String? gender;
  final String? profileImage;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.calories,
    required this.protein,
    required this.water,
    this.gender,
    this.profileImage,
  });

  String getProfileImage() {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return profileImage!;
    }
    return gender == "Male"
        ? 'assets/images/man_user.png'
        : 'assets/images/women_user.png';
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear user session

    // Navigate to user info input screen and clear stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const UserInformation()),
          (route) => false,
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: AssetImage(getProfileImage()),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGoalRow(Icons.local_fire_department, "Calories Goal", "${calories.toStringAsFixed(2)} kcal"),
                    const Divider(),
                    _buildGoalRow(Icons.fitness_center, "Protein Goal", "${protein.toStringAsFixed(2)} g"),
                    const Divider(),
                    _buildGoalRow(Icons.water_drop, "Water Intake", "$water L"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuItem(Icons.settings, "Settings", () => _navigateTo(context, '/settings')),
            _buildMenuItem(Icons.info, "About App", () => _navigateTo(context, '/about')),
            _buildMenuItem(Icons.help, "Help & Support", () => _navigateTo(context, '/support')),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 28),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
