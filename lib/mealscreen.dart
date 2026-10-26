import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'nutritionix_config.dart';

class MealScreen extends StatefulWidget {
  final String mealType;
  const MealScreen({Key? key, required this.mealType}) : super(key: key);

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final TextEditingController foodNameController = TextEditingController();
  double? calories;
  double? protein;
  double? carbs;
  double? fats;
  bool isLoading = false;

  Future<void> _searchFood() async {
    final query = foodNameController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a food name')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url =
        Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients');
    final headers = nutritionixHeaders();
    final body = jsonEncode({'query': query});

    try {
      final response = await http.post(url, headers: headers, body: body);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['foods'] != null &&
          data['foods'].isNotEmpty) {
        final food = data['foods'][0];
        setState(() {
          foodNameController.text = food['food_name'];
          calories = food['nf_calories']?.toDouble();
          protein = food['nf_protein']?.toDouble();
          carbs = food['nf_total_carbohydrate']?.toDouble();
          fats = food['nf_total_fat']?.toDouble();
          isLoading = false;
        });
      } else {
        throw Exception("Food not found");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _saveMeal() {
    if (foodNameController.text.isEmpty ||
        calories == null ||
        protein == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search and select a valid food.')),
      );
      return;
    }
    Navigator.pop(context, {
      'foodName': foodNameController.text,
      'calories': calories,
      'protein': protein,
      'carbs': carbs ?? 0.0,
      'fats': fats ?? 0.0,
    });
  }

  @override
  void dispose() {
    foodNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add ${widget.mealType} Meal"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Food Name search field
              TextField(
                controller: foodNameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _searchFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Search Food"),
              ),
              const SizedBox(height: 24),
              if (calories != null && protein != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Calories: ${calories!.toStringAsFixed(2)}"),
                    Text("Protein: ${protein!.toStringAsFixed(2)} g"),
                    Text("Carbs: ${carbs?.toStringAsFixed(2) ?? 0} g"),
                    Text("Fats: ${fats?.toStringAsFixed(2) ?? 0} g"),
                  ],
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveMeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Save Meal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
