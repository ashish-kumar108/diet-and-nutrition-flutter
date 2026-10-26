import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginui.dart';
import 'mealscreen.dart';
import 'nutritionix_config.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  final double calories, protein, water, carbGoal, fatGoal;
  final double consumedCalories,
      consumedProtein,
      consumedCarbs,
      consumedFats,
      consumedWater;
  final void Function(String category, Map<String, dynamic> mealData) onAddMeal;
  final void Function(double) onAddWater;

  const HomeScreen({
    Key? key,
    required this.name,
    required this.calories,
    required this.protein,
    required this.water,
    required this.carbGoal,
    required this.fatGoal,
    required this.consumedCalories,
    required this.consumedProtein,
    required this.consumedCarbs,
    required this.consumedFats,
    required this.consumedWater,
    required this.onAddMeal,
    required this.onAddWater,
  }) : super(key: key);

  Future<void> _navigateToMealScreen(
      BuildContext context, String mealType) async {
    final mealData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealScreen(mealType: mealType)),
    );
    if (mealData != null && mealData is Map<String, dynamic>) {
      onAddMeal(mealType, mealData);
    }
  }

  void _addRecommendedMeal(
      BuildContext context, Map<String, dynamic> meal) async {
    final selectedCategory = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text("Select a Meal Category")),
            ListTile(
                leading: const Icon(Icons.free_breakfast),
                title: const Text("Breakfast"),
                onTap: () => Navigator.pop(ctx, "Breakfast")),
            ListTile(
                leading: const Icon(Icons.lunch_dining),
                title: const Text("Lunch"),
                onTap: () => Navigator.pop(ctx, "Lunch")),
            ListTile(
                leading: const Icon(Icons.cookie),
                title: const Text("Snacks"),
                onTap: () => Navigator.pop(ctx, "Snacks")),
            ListTile(
                leading: const Icon(Icons.restaurant),
                title: const Text("Dinner"),
                onTap: () => Navigator.pop(ctx, "Dinner")),
          ],
        );
      },
    );

    if (selectedCategory == null) return;

    final Map<String, dynamic> mealData = {
      'foodName': meal['food_name'],
      'calories': meal['nf_calories'] ?? 0.0,
      'protein': meal['nf_protein'] ?? 0.0,
      'carbs': meal['nf_total_carbohydrate'] ?? 0.0,
      'fats': meal['nf_total_fat'] ?? 0.0,
    };

    onAddMeal(selectedCategory, mealData);
  }

  Future<List<Map<String, dynamic>>> fetchRecommendedMealsFromAPI(
      double remainingCalories) async {
    // Suggested vegetarian meals based on calorie goal
    final suggestions = remainingCalories < 200
        ? ["apple", "greek yogurt", "almonds", "sprouts"]
        : ["paneer bhurji", "tofu stir fry", "dal rice", "vegetable khichdi"];

    // Join all suggested items into one query
    final query = suggestions.join(", ");

    final response = await http.post(
      Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients"),
      headers: nutritionixHeaders(),
      body: jsonEncode({"query": query}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final foods = List<Map<String, dynamic>>.from(data["foods"]);
      return foods;
    } else {
      throw Exception("Failed to fetch meals from API");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double calorieProgress = (consumedCalories / calories).clamp(0, 1);
    final double proteinProgress = (consumedProtein / protein).clamp(0, 1);
    final double waterProgress = (consumedWater / water).clamp(0, 1);
    final double remainingCalories = calories - consumedCalories;

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, $name"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginUi()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Today's Progress",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressCircle(
                    "Calories",
                    calorieProgress,
                    "${(calorieProgress * 100).toStringAsFixed(0)}%",
                    Colors.deepPurple),
                _buildProgressCircle(
                    "Protein",
                    proteinProgress,
                    "${(proteinProgress * 100).toStringAsFixed(0)}%",
                    Colors.orange),
                _buildProgressCircle(
                    "Water",
                    waterProgress,
                    "${(waterProgress * 100).toStringAsFixed(0)}%",
                    Colors.blue),
              ],
            ),
            const SizedBox(height: 8),
            Text(
                "Remaining Calories: ${remainingCalories.toStringAsFixed(0)} kcal",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text("Quick Add Meal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMealButton(context, "Breakfast", Icons.free_breakfast,
                      Colors.deepPurple),
                  const SizedBox(width: 8),
                  _buildMealButton(
                      context, "Lunch", Icons.lunch_dining, Colors.orange),
                  const SizedBox(width: 8),
                  _buildMealButton(
                      context, "Snacks", Icons.cookie, Colors.green),
                  const SizedBox(width: 8),
                  _buildMealButton(
                      context, "Dinner", Icons.restaurant, Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                          "Water: ${consumedWater.toStringAsFixed(2)} L / ${water.toStringAsFixed(2)} L",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                  ElevatedButton(
                    onPressed: () => onAddWater(0.25),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Add 250ml"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Nutrition Breakdown",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildNutritionRow(
                "Carbohydrates", consumedCarbs, carbGoal, Colors.deepPurple),
            _buildNutritionRow(
                "Protein", consumedProtein, protein, Colors.orange),
            _buildNutritionRow("Fats", consumedFats, fatGoal, Colors.red),
            const SizedBox(height: 24),
            const Text("Recommended Meals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchRecommendedMealsFromAPI(remainingCalories),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text("Error loading recommended meals.");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No recommended meals found.");
                } else {
                  final meals = snapshot.data!;
                  return Column(
                    children: meals.map((meal) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 3,
                        child: ListTile(
                          leading: const Icon(Icons.fastfood),
                          title: Text(
                            meal['food_name'].toString().toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Calories: ${meal['nf_calories']?.toStringAsFixed(0) ?? '0'} kcal\n"
                            "Protein: ${meal['nf_protein'] ?? 0}g | Carbs: ${meal['nf_total_carbohydrate'] ?? 0}g | Fats: ${meal['nf_total_fat'] ?? 0}g",
                          ),
                          isThreeLine: true,
                          trailing: InkWell(
                            onTap: () => _addRecommendedMeal(context, meal),
                            child: const Icon(Icons.add_circle_outline,
                                color: Colors.green),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCircle(
      String label, double progress, String value, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 44,
          lineWidth: 8,
          animation: true,
          percent: progress.clamp(0.0, 1.0),
          center: Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          progressColor: color,
          backgroundColor: Colors.grey.shade300,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildMealButton(
      BuildContext context, String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () => _navigateToMealScreen(context, label),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildNutritionRow(
      String label, double consumed, double goal, Color color) {
    final double progress =
        (goal == 0) ? 0.0 : (consumed / goal).clamp(0.0, 1.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "$label (${consumed.toStringAsFixed(0)}/${goal.toStringAsFixed(0)}g)",
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          backgroundColor: Colors.grey.shade300,
          color: color,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
