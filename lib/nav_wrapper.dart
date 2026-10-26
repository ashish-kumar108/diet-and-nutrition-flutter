import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'home_screen.dart';
import 'mealcatagory_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';

class NavWrapper extends StatefulWidget {
  final String name;
  final double calories;
  final double protein;
  final double water;
  final double dailyCarbGoal;
  final double dailyFatGoal;
  final String gender;

  const NavWrapper({
    super.key,
    required this.name,
    required this.calories,
    required this.protein,
    required this.water,
    required this.dailyCarbGoal,
    required this.dailyFatGoal,
    required this.gender,
  });

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> breakfastMeals = [];
  List<Map<String, dynamic>> lunchMeals = [];
  List<Map<String, dynamic>> snacksMeals = [];
  List<Map<String, dynamic>> dinnerMeals = [];

  double consumedCalories = 0;
  double consumedProtein = 0;
  double consumedCarbs = 0;
  double consumedFats = 0;
  double consumedWater = 0;

  @override
  void initState() {
    super.initState();
    _loadMealProgress();
  }

  Future<void> _loadMealProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      consumedCalories = prefs.getDouble('consumedCalories') ?? 0;
      consumedProtein = prefs.getDouble('consumedProtein') ?? 0;
      consumedCarbs = prefs.getDouble('consumedCarbs') ?? 0;
      consumedFats = prefs.getDouble('consumedFats') ?? 0;
      consumedWater = prefs.getDouble('consumedWater') ?? 0;

      breakfastMeals = List<Map<String, dynamic>>.from(
        jsonDecode(prefs.getString('breakfastMeals') ?? '[]'),
      );
      lunchMeals = List<Map<String, dynamic>>.from(
        jsonDecode(prefs.getString('lunchMeals') ?? '[]'),
      );
      snacksMeals = List<Map<String, dynamic>>.from(
        jsonDecode(prefs.getString('snacksMeals') ?? '[]'),
      );
      dinnerMeals = List<Map<String, dynamic>>.from(
        jsonDecode(prefs.getString('dinnerMeals') ?? '[]'),
      );
    });
  }

  Future<void> _saveMealProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('consumedCalories', consumedCalories);
    await prefs.setDouble('consumedProtein', consumedProtein);
    await prefs.setDouble('consumedCarbs', consumedCarbs);
    await prefs.setDouble('consumedFats', consumedFats);
    await prefs.setDouble('consumedWater', consumedWater);

    await prefs.setString('breakfastMeals', jsonEncode(breakfastMeals));
    await prefs.setString('lunchMeals', jsonEncode(lunchMeals));
    await prefs.setString('snacksMeals', jsonEncode(snacksMeals));
    await prefs.setString('dinnerMeals', jsonEncode(dinnerMeals));
  }

  void _addMealToCategory(String category, Map<String, dynamic> mealData) {
    setState(() {
      switch (category) {
        case 'Breakfast':
          breakfastMeals.add(mealData);
          break;
        case 'Lunch':
          lunchMeals.add(mealData);
          break;
        case 'Snacks':
          snacksMeals.add(mealData);
          break;
        case 'Dinner':
          dinnerMeals.add(mealData);
          break;
      }

      consumedCalories += mealData['calories'] ?? 0;
      consumedProtein += mealData['protein'] ?? 0;
      consumedCarbs += mealData['carbs'] ?? 0;
      consumedFats += mealData['fats'] ?? 0;

      _saveMealProgress();
    });
  }

  void _addWater(double liters) {
    setState(() {
      consumedWater += liters;
      _saveMealProgress();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getProfileImage() {
    if (widget.gender.toLowerCase() == 'male') {
      return 'assets/images/man_user.png';
    } else if (widget.gender.toLowerCase() == 'female') {
      return 'assets/images/women_user.png';
    } else {
      return 'assets/profile_default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        name: widget.name,
        calories: widget.calories,
        protein: widget.protein,
        water: widget.water,
        carbGoal: widget.dailyCarbGoal,
        fatGoal: widget.dailyFatGoal,
        consumedCalories: consumedCalories,
        consumedProtein: consumedProtein,
        consumedCarbs: consumedCarbs,
        consumedFats: consumedFats,
        consumedWater: consumedWater,
        onAddMeal: _addMealToCategory,
        onAddWater: _addWater,
      ),
      MealsCategoryScreen(
        userName: widget.name,
        breakfastMeals: breakfastMeals,
        lunchMeals: lunchMeals,
        snacksMeals: snacksMeals,
        dinnerMeals: dinnerMeals,
      ),
      AnalyticsScreen(
        consumedCalories: consumedCalories,
        consumedProtein: consumedProtein,
        consumedCarbs: consumedCarbs,
        consumedFats: consumedFats,
      ),
      ProfileScreen(
        name: widget.name,
        calories: widget.calories,
        protein: widget.protein,
        water: widget.water,
        profileImage: getProfileImage(),
      ),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Meals'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
