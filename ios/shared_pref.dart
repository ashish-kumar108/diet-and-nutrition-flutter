import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTrackingData({
  required double consumedCalories,
  required double consumedProtein,
  required double consumedCarbs,
  required double consumedFats,
  required double consumedWater,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('consumedCalories', consumedCalories);
  await prefs.setDouble('consumedProtein', consumedProtein);
  await prefs.setDouble('consumedCarbs', consumedCarbs);
  await prefs.setDouble('consumedFats', consumedFats);
  await prefs.setDouble('consumedWater', consumedWater);
}
