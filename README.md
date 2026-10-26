# Diet & Nutrition

A Flutter nutrition companion for calorie tracking, meal discovery and progress analytics.

## Highlights

- Personalized calorie and macro targets
- Nutritionix-powered food search and meal suggestions
- Meal-category tracking for breakfast, lunch, snacks and dinner
- Progress charts and daily nutrition analytics
- Local persistence with SharedPreferences
- Reusable, responsive Flutter screens

## Tech stack

Flutter, Dart, HTTP, Nutritionix API, FL Chart, Percent Indicator and SharedPreferences.

## Run locally

```bash
flutter pub get
flutter run \
  --dart-define=NUTRITIONIX_APP_ID=your_app_id \
  --dart-define=NUTRITIONIX_APP_KEY=your_app_key
```

API credentials are intentionally excluded from source control.

## Project status

Portfolio project demonstrating API integration, stateful nutrition workflows, data visualization and responsive Flutter UI.
