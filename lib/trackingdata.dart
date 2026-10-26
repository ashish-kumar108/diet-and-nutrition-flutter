import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define your state classes
abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final int water;

  TrackingLoaded({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.water,
  });
}

// Define your Cubit
class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit() : super(TrackingInitial()) {
    loadTrackingData();
  }

  Future<void> loadTrackingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int consumedCalories = prefs.getInt('consumedCalories') ?? 0;
    int consumedProtein = prefs.getInt('consumedProtein') ?? 0;
    int consumedCarbs = prefs.getInt('consumedCarbs') ?? 0;
    int consumedFats = prefs.getInt('consumedFats') ?? 0;
    int consumedWater = prefs.getInt('consumedWater') ?? 0;

    emit(TrackingLoaded(
      calories: consumedCalories,
      protein: consumedProtein,
      carbs: consumedCarbs,
      fats: consumedFats,
      water: consumedWater,
    ));
  }
}
