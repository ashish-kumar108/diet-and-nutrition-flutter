import 'dart:convert';
import 'package:http/http.dart' as http;
import 'nutritionix_config.dart';

Future<List<Map<String, dynamic>>> fetchRecommendedMeals(
    double remainingCalories) async {
  final query = 'meals'; // You can make this dynamic too
  final url = Uri.parse(
    'https://trackapi.nutritionix.com/v2/search/instant?query=$query',
  );

  final headers = nutritionixHeaders();

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final commonFoods = data['common'] as List;

    final filtered = <Map<String, dynamic>>[];

    for (final item in commonFoods) {
      final name = item['food_name'];
      final imageUrl = item['photo']['thumb'];

      final detailResponse = await http.post(
        Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients'),
        headers: headers,
        body: jsonEncode({'query': name}),
      );

      if (detailResponse.statusCode == 200) {
        final detailData = jsonDecode(detailResponse.body);
        final food = detailData['foods'][0];

        final calories = food['nf_calories'];
        if (calories <= remainingCalories) {
          filtered.add({
            'name': name,
            'image': imageUrl,
            'calories': calories,
            'protein': food['nf_protein'],
            'carbs': food['nf_total_carbohydrate'],
            'fats': food['nf_total_fat'],
          });
        }
      }

      if (filtered.length >= 3) break; // limit to 3 meals
    }

    return filtered;
  } else {
    throw Exception("Failed to fetch meals");
  }
}
