import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nav_wrapper.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  String? selectedActivityLevel;
  String? selectedGoal;
  String? selectedGender;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  "Help us customize your experience",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Name Field
            _buildTextField(nameController, "Name"),
            const SizedBox(height: 15),
            _buildTextField(heightController, "Height (cm)", isNumber: true),
            const SizedBox(height: 15),
            _buildTextField(weightController, "Weight (kg)", isNumber: true),
            const SizedBox(height: 15),
            _buildTextField(ageController, "Age (years)", isNumber: true),
            const SizedBox(height: 15),
            _buildGenderSelector(),
            const SizedBox(height: 15),
            _buildDropdown(
              value: selectedActivityLevel,
              hint: "Select Activity level",
              items: [
                'Sedentary',
                'Lightly Active',
                'Moderately Active',
                'Very Active',
                'Extra Active'
              ],
              onChanged: (value) => setState(() => selectedActivityLevel = value),
            ),
            const SizedBox(height: 15),
            _buildDropdown(
              value: selectedGoal,
              hint: "Select a Goal to Track",
              items: ["Gain Muscle", "Lose Weight", "Maintain Weight"],
              onChanged: (value) => setState(() => selectedGoal = value),
            ),
            const SizedBox(height: 15),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Radio<String>(
            value: "Male",
            groupValue: selectedGender,
            onChanged: (value) => setState(() => selectedGender = value),
            activeColor: Colors.green,
          ),
          const Text("Male", style: TextStyle(fontSize: 17)),
          Radio<String>(
            value: "Female",
            groupValue: selectedGender,
            onChanged: (value) => setState(() => selectedGender = value),
            activeColor: Colors.green,
          ),
          const Text("Female", style: TextStyle(fontSize: 17)),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          underline: const SizedBox(),
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            final String name = nameController.text;
            final double height = double.tryParse(heightController.text) ?? 0.0;
            final double weight = double.tryParse(weightController.text) ?? 0.0;
            final int age = int.tryParse(ageController.text) ?? 0;
            final String? gender = selectedGender;
            final String? activityLevel = selectedActivityLevel;
            final String? goal = selectedGoal;

            if (weight <= 0 || height <= 0 || age <= 0 || gender == null || activityLevel == null || goal == null) {
              debugPrint("Please provide valid inputs.");
              return;
            }

            double bmi = weight / ((height / 100) * (height / 100));

            double bmr = (gender == "Male")
                ? (88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age))
                : (447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age));

            double activityFactor = {
              'Sedentary': 1.2,
              'Lightly Active': 1.375,
              'Moderately Active': 1.55,
              'Very Active': 1.725,
              'Extra Active': 1.9
            }[activityLevel] ?? 1.0;

            double tdee = bmr * activityFactor;
            double requiredCalories = tdee;

            if (goal == "Gain Muscle") {
              requiredCalories += 500;
            } else if (goal == "Lose Weight") {
              requiredCalories -= 500;
            }

            if (goal == "Lose Weight" && bmi < 18.5) {
              _showGoalWarningDialog(
                context,
                "Low BMI Warning",
                "Your BMI is too low (currently ${bmi.toStringAsFixed(1)}). Losing more weight may harm your health. "
                    "We recommend choosing 'Gain Muscle' or 'Maintain Weight' to help improve your overall fitness.",
              );
              return;
            } else if (goal == "Gain Muscle" && bmi > 30) {
              _showGoalWarningDialog(
                context,
                "High BMI Warning",
                "Your BMI indicates obesity (currently ${bmi.toStringAsFixed(1)}). Gaining more weight may not be ideal. "
                    "We recommend choosing 'Lose Weight' or 'Maintain Weight' to help improve your health.",
              );
              return;
            }

            saveUserDetails(
              name: name,
              age: age,
              height: height,
              weight: weight,
              goal: goal,
              activityLevel: activityLevel,
              gender: gender,
              calories: requiredCalories,
            );
          },
          child: const Text("Continue", style: TextStyle(fontSize: 18, fontFamily: 'Roboto', color: Colors.white)),
        ),
      ),
    );
  }

  void _showGoalWarningDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void saveUserDetails({
    required String name,
    required int age,
    required double height,
    required double weight,
    required String goal,
    required String activityLevel,
    required String gender,
    required double calories,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    double protein = weight * 2; // Example: 2g protein per kg
    double fat = (calories * 0.25) / 9; // 25% of calories from fat
    double carbs = (calories - (protein * 4) - (fat * 9)) / 4;
    double water = weight * 35 / 1000; // water in litres (35ml per kg)

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('name', name);
    await prefs.setDouble('calories', calories);
    await prefs.setDouble('protein', protein);
    await prefs.setDouble('fatGoal', fat);
    await prefs.setDouble('carbGoal', carbs);
    await prefs.setDouble('water', water);
    await prefs.setString('gender', gender);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NavWrapper(
          name: name,
          calories: calories,
          protein: protein,
          water: water,
          dailyCarbGoal: carbs,
          dailyFatGoal: fat,
          gender: gender,
        ),
      ),
    );
  }
}
