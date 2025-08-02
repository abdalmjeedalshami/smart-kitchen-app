import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/meals/meal_provider.dart';
import '../../../providers/meals/meal_state.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/responsive_util.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/meals_slider.dart';
import '../../../widgets/poppins_text.dart';
import '../../../widgets/search_field.dart';
import '../../../widgets/titles_slider.dart';
import '../../../widgets/welcome_dialog.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, this.onSearch});

  final TextEditingController searchController = TextEditingController();
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: appBar(context),
        body: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: responsive(context, 16)),
                child: SearchField(controller: searchController),
              ),

              // Image with text and button
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: responsive(context, 16)),
                child: welcomeWidget(context,
                    imagePath: AppImages.welcomeImage,
                    title: locale.welcome_card_title,
                    buttonText: locale.book_now),
              ),

              // Center Text with "View All" in the right
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive(context, 16),
                    vertical: responsive(context, 18)),
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    GestureDetector(
                        child: PoppinsText.medium(locale.view_all,
                            fontSize: responsive(context, 10),
                            color: AppColors.redColor)),
                    Center(
                        child: PoppinsText.medium(locale.choose_a_meal,
                            fontSize: responsive(context, 20),
                            color: AppColors.primary)),
                  ],
                ),
              ),

              // Titles slider
              titlesSlider(context),
              SizedBox(height: responsive(context, 16)),

              // Vertical meal cards
              // Horizontal meal slider
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

                  // ProMealCard(
                  //   title: 'Grilled Chicken Salad',
                  //   description: 'High-protein, low-carb meal for healthy living.',
                  //   imageUrl: 'https://tse2.mm.bing.net/th/id/OIP.xnOdHsT-Ny1NUwz1uv5r-AHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
                  //   calories: 420,
                  //   safeFor: ['Diabetic Safe', 'Gluten-Free'],
                  //   onAdd: () {
                  //     print('Meal added');
                  //   },
                  //   isFavorite: true,
                  //   onFavoriteToggle: () {
                  //     print('Toggled favorite');
                  //   },
                  // )

                ])));
  }
}
