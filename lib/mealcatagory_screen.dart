import 'package:flutter/material.dart';

class MealsCategoryScreen extends StatefulWidget {
  final String userName;
  final List<Map<String, dynamic>> breakfastMeals;
  final List<Map<String, dynamic>> lunchMeals;
  final List<Map<String, dynamic>> snacksMeals;
  final List<Map<String, dynamic>> dinnerMeals;

  const MealsCategoryScreen({
    Key? key,
    required this.userName,
    required this.breakfastMeals,
    required this.lunchMeals,
    required this.snacksMeals,
    required this.dinnerMeals,
  }) : super(key: key);

  @override
  State<MealsCategoryScreen> createState() => _MealsCategoryScreenState();
}

class _MealsCategoryScreenState extends State<MealsCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meals for ${widget.userName}"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMealCategory("Breakfast", widget.breakfastMeals),
            _buildMealCategory("Lunch", widget.lunchMeals),
            _buildMealCategory("Snacks", widget.snacksMeals),
            _buildMealCategory("Dinner", widget.dinnerMeals),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCategory(String title, List<Map<String, dynamic>> meals) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              meals.isEmpty
                  ? const Text(
                "No meals added yet.",
                style: TextStyle(color: Colors.grey),
              )
                  : SizedBox(
                height: meals.length * 70, // dynamic height based on number of meals
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.fastfood, color: Colors.green),
                      title: Text(meal['foodName'] ?? "Unknown"),
                      subtitle: Text(
                        "Calories: ${meal['calories']} | Protein: ${meal['protein']}g",
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
