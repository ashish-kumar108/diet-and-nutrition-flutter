const nutritionixAppId = String.fromEnvironment('NUTRITIONIX_APP_ID');
const nutritionixAppKey = String.fromEnvironment('NUTRITIONIX_APP_KEY');

Map<String, String> nutritionixHeaders() {
  if (nutritionixAppId.isEmpty || nutritionixAppKey.isEmpty) {
    throw StateError(
      'Nutritionix credentials are missing. Provide NUTRITIONIX_APP_ID and '
      'NUTRITIONIX_APP_KEY with --dart-define.',
    );
  }

  return {
    'x-app-id': nutritionixAppId,
    'x-app-key': nutritionixAppKey,
    'Content-Type': 'application/json',
  };
}
