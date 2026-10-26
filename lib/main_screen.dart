import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Track the currently selected tab.
  int _selectedIndex = 0;

  // List of screens (replace with your own screens).
  final List<Widget> _screens = [
    const HomePage(),
    const MealsPage(),
    const AnalyticsPage(),
    const ProfilePage(),
  ];

  // Called when the user taps on a bottom navigation item.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the currently selected screen in the body.
      body: _screens[_selectedIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Show labels always (or set to BottomNavigationBarType.fixed).
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green, // Customize the active icon color
        unselectedItemColor: Colors.black54, // Customize the inactive icon color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights), // or any icon representing analytics
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Placeholder Screens
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Home Screen"));
  }
}

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Meals Screen"));
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Analytics Screen"));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile Screen"));
  }
}
