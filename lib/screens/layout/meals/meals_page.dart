import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../providers/meals/meal_provider.dart';
import '../../../providers/meals/meal_state.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive_util.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/meals_slider.dart';
import '../../../widgets/search_field.dart';
import '../../../widgets/titles_slider.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late ScrollController scrollController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double initialPosition = 20 * 2;
      scrollController.jumpTo(initialPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: responsive(context, 16), bottom: responsive(context, 50)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: responsive(context, 16)),
                child: SearchField(controller: searchController),
              ),

              // Titles slider
              titlesSlider(context, selectedColor: AppColors.earthyBrown),
              SizedBox(height: responsive(context, 16)),

              // Horizontal meal slider of vertical meal cards
              BlocBuilder<MealCubit, MealState>(
                builder: (context, state) {
                  if (state is MealLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MealsLoaded && state.meals.isEmpty) {
                    return const Center(child: Text('No meals available'));
                  } else if (state is MealError) {
                    return Center(child: Text(state.message));
                  } else if (state is MealsLoaded) {
                    return mealsSlider(context, meals: state.meals);
                  }
                  return const Center(child: Text("No meals available"));
                },
              ),
              SizedBox(height: responsive(context, 12)),
              BlocBuilder<MealCubit, MealState>(
                builder: (context, state) {
                  if (state is MealLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MealsLoaded && state.meals.isEmpty) {
                    return const Center(child: Text('No meals available'));
                  } else if (state is MealError) {
                    return Center(child: Text(state.message));
                  } else if (state is MealsLoaded) {
                    return mealsSlider(context, meals: state.meals, controller: scrollController);
                  }
                  return const Center(child: Text("No meals available"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
