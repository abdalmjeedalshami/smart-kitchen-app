import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/meal_model.dart';
import '../../services/database_helper.dart';
import '../../utils/images.dart';
import 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final DatabaseHelper databaseHelper;

  MealCubit(this.databaseHelper) : super(MealInitial());

  List<Meal> meals = [];
  List<Meal> booked = [];
  List<Meal> past = [];

  void addSampleMeals(DatabaseHelper databaseHelper) async {
    List<Meal> meals = [
      Meal(
        name: "Deluxe Suite",
        image: AppImages.meal_1,
        requiredTime: 300.0,
        rate: 1,
        available: true,
        description: "A luxurious suite with stunning views.",
        images: [
          AppImages.meal_1,
          AppImages.meal_2,
          AppImages.meal_3,
          AppImages.meal_4
        ],
        vegetarianFriendly: true,
        glutenFree: true,
        allergySafe: false,
        lowCalorie: false,
      ),
      Meal(
          name: "Ocean View",
          image: AppImages.meal_2,
          requiredTime: 180.0,
          rate: 2,
          available: false,
          description: "Enjoy beautiful ocean views.",
          images: [
            AppImages.meal_5,
            AppImages.meal_6,
            AppImages.meal_1,
            AppImages.meal_4
          ],
          vegetarianFriendly: true,
          glutenFree: true,
          allergySafe: false,
          lowCalorie: false
          ),
      Meal(
          name: "Mountain Retreat",
          image: AppImages.meal_3,
          requiredTime: 150.0,
          rate: 3,
          available: true,
          description: "A cozy retreat in the mountains.",
          images: [
            AppImages.meal_4,
            AppImages.meal_3,
            AppImages.meal_2,
            AppImages.meal_1
          ],
          vegetarianFriendly: true,
          glutenFree: true,
          allergySafe: false,
          lowCalorie: false
          ),
      Meal(
          name: "City Apartment",
          image: AppImages.meal_4,
          requiredTime: 120.0,
          rate: 4,
          available: false,
          description: "A convenient apartment in the heart of the city.",
          images: [
            AppImages.meal_2,
            AppImages.meal_1,
            AppImages.meal_6,
            AppImages.meal_4
          ],
          vegetarianFriendly: true,
          glutenFree: true,
          allergySafe: false,
          lowCalorie: false
          ),
      Meal(
          name: "Beach Bungalow",
          image: AppImages.meal_5,
          requiredTime: 250.0,
          rate: 5,
          available: true,
          description: "A beautiful bungalow by the beach.",
          images: [
            AppImages.meal_2,
            AppImages.meal_3,
            AppImages.meal_5,
            AppImages.meal_4
          ],
          vegetarianFriendly: true,
          glutenFree: true,
          allergySafe: false,
          lowCalorie: false
          ),
    ];

    for (Meal meal in meals) {
      await databaseHelper.insertMeal(meal);
    }
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    try {
      meals.clear();
      booked.clear();
      past.clear();
      emit(MealLoading());
      final allMeals = await databaseHelper.fetchMeals();
      for (Meal meal in allMeals) {
        meal.status == 'booked'
            ? booked.add(meal)
            : meal.status == 'past'
                ? past.add(meal)
                : meals.add(meal);
      }
      emit(MealsLoaded(meals));
    } catch (e) {
      emit(MealError('Failed to load meals: $e'));
    }
  }

  Future<void> deleteDatabaseFile() async {
    try {
      await DatabaseHelper.deleteDatabaseFile();
      emit(DatabaseDeleted());
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> deleteMeals() async {
    try {
      await DatabaseHelper.deleteMeals();
      emit(DatabaseDeleted());
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }
}
