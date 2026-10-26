import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserInformation.dart';
import 'nav_wrapper.dart';
import 'loginui.dart';
import 'setting.dart';
import 'about_app.dart';
import 'support_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diet and Nutrition Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const EntryPoint(),
      routes: {
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutAppScreen(),
        '/support': (context) => const SupportScreen(),
      },
    );
  }
}

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool isLoading = true;
  bool isFirstLaunch = true;
  bool isLoggedIn = false;

  // user data
  String name = '';
  double calories = 0;
  double protein = 0;
  double water = 0;
  double carbGoal = 0;
  double fatGoal = 0;
  String gender = '';

  @override
  void initState() {
    super.initState();
    loadAppState();
  }

  Future<void> loadAppState() async {
    final prefs = await SharedPreferences.getInstance();

    isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      name = prefs.getString('name') ?? '';
      calories = prefs.getDouble('calories') ?? 0;
      protein = prefs.getDouble('protein') ?? 0;
      water = prefs.getDouble('water') ?? 0;
      carbGoal = prefs.getDouble('carbGoal') ?? 0;
      fatGoal = prefs.getDouble('fatGoal') ?? 0;
      gender = prefs.getString('gender') ?? '';
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isFirstLaunch) {
      return const LoginUi(); // First time: show login screen
    } else if (!isLoggedIn) {
      return const UserInformation(); // Not logged in: get user info
    } else {
      return NavWrapper(
        name: name,
        calories: calories,
        protein: protein,
        water: water,
        dailyCarbGoal: carbGoal,
        dailyFatGoal: fatGoal,
        gender: gender,
      );
    }
  }
}
