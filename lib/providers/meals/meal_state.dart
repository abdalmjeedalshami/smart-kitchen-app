import '../../models/meal_model.dart';

abstract class MealState {}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealsLoaded extends MealState {
  final List<Meal> meals;

  MealsLoaded(this.meals);
}
class MealsAdded extends MealState {}

class MealError extends MealState {
  final String message;

  MealError(this.message);
}

class DatabaseDeleted extends MealState {}
