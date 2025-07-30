import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_app_planner/utils/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/meal_model.dart';
import '../../providers/meals/meal_provider.dart';
import '../../providers/meals/meal_state.dart';
import '../../services/database_helper.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/navigation_util.dart';
import '../../utils/responsive_util.dart';
import '../../widgets/poppins_text.dart';

class MealPage extends StatelessWidget {
  final Meal meal;

  const MealPage({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Image
              Container(
                height: responsive(context, 450),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(meal.image), fit: BoxFit.cover),
                ),
              ),
              // Filter
              Container(
                height: responsive(context, 450),
                color: AppColors.transparentCharcoal,
                child: const Stack(),
              ),
              // Back & Fav
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive(context, 16),
                    vertical: responsive(context, 25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        height: responsive(context, 30),
                        width: responsive(context, 30),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(responsive(context, 8)),
                          child: SvgPicture.asset(
                            AppIcons.backArrow,
                            width: responsive(context, 10),
                            height: responsive(context, 10),
                            colorFilter: const ColorFilter.mode(
                                AppColors.darkGray_1, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                          height: responsive(context, 30),
                          width: responsive(context, 30),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: AppColors.redColor,
                          )),
                    )
                  ],
                ),
              ),
              // info
              Container(
                margin:
                    EdgeInsetsDirectional.only(top: responsive(context, 250)),
                height: responsive(context, 200),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: responsive(context, 12),
                      top: responsive(context, 12),
                      right: responsive(context, 5),
                      bottom: responsive(context, 12)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: responsive(context, 25)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Meal Name & Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Meal name
                            Expanded(
                              child: PoppinsText.semiBold(meal.name,
                                  fontSize: responsive(context, 25),
                                  color: AppColors.white),
                            ),
                            // Stars Rating
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < meal.rate
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                  size: responsive(context, 11),
                                );
                              }),
                            ),
                          ],
                        ),
                        // Price & Available
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PoppinsText.medium(
                                '\$${meal.requiredTime.toStringAsFixed(2)} ${locale.min}',
                                fontSize: responsive(context, 18),
                                color: AppColors.white),
                            PoppinsText.semiBold(
                                meal.available
                                    ? locale.available
                                    : locale.unavailable,
                                fontSize: responsive(context, 10),
                                color: meal.available
                                    ? AppColors.white
                                    : AppColors.redColor),
                          ],
                        ),
                        // Features Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: responsive(context, 8)),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          responsive(context, 12)),
                                      child: SvgPicture.asset(
                                        AppIcons.eco,
                                        height: responsive(context, 25),
                                        width: responsive(context, 25),
                                        colorFilter: ColorFilter.mode(
                                            meal.vegetarianFriendly ? Colors.blue : Colors.grey,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: responsive(context, 5)),
                                  PoppinsText.medium('Vegetarian Friendly',
                                      fontSize: responsive(context, 8),
                                      color: AppColors.white)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: responsive(context, 8)),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          responsive(context, 12)),
                                      child: SvgPicture.asset(
                                        AppIcons.kitchen,
                                        height: responsive(context, 25),
                                        width: responsive(context, 25),
                                        colorFilter: ColorFilter.mode(
                                            meal.glutenFree
                                                ? Colors.blue
                                                : Colors.grey,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: responsive(context, 5)),
                                  PoppinsText.medium('Gluten Free',
                                      fontSize: responsive(context, 8),
                                      color: AppColors.white)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: responsive(context, 8)),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          responsive(context, 12)),
                                      child: SvgPicture.asset(
                                        AppIcons.bedtime,
                                        height: responsive(context, 25),
                                        width: responsive(context, 25),
                                        colorFilter: ColorFilter.mode(
                                            meal.allergySafe
                                                ? Colors.blue
                                                : Colors.grey,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: responsive(context, 5)),
                                  PoppinsText.medium('Allergy Safe',
                                      fontSize: responsive(context, 8),
                                      color: AppColors.white)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: responsive(context, 8)),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          responsive(context, 12)),
                                      child: SvgPicture.asset(
                                        AppIcons.waterLoss,
                                        height: responsive(context, 25),
                                        width: responsive(context, 25),
                                        colorFilter: ColorFilter.mode(
                                            meal.lowCalorie
                                                ? Colors.blue
                                                : Colors.grey,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: responsive(context, 5)),
                                  PoppinsText.medium('Water Loss',
                                      fontSize: responsive(context, 8),
                                      color: AppColors.white)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsive(context, 16),
                vertical: responsive(context, 12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                PoppinsText.semiBold(
                  'Meal Specifications',
                  color: Theme.of(context).socialLoginButtonColor,
                ),
                // Description
                PoppinsText.regular(meal.description,
                    fontSize: responsive(context, 13),
                    color: Theme.of(context).customTextFieldIconColor,
                    overflow: TextOverflow.visible),
              ],
            ),
          )),
          // Photos
          SizedBox(
            height: responsive(context, 130),
            child: ListView.builder(
              itemCount: meal.images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  height: double.infinity,
                  width: responsive(context, 130),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage(meal.images[index]),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          BlocBuilder<MealCubit, MealState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive(context, 16),
                    vertical: responsive(context, 33)),
                child: SizedBox(
                  width: double.infinity,
                  height: responsive(context, 55),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: meal.available
                          ? Theme.of(context).primaryColor
                          : AppColors.darkGray_1,
                      foregroundColor:
                          meal.available ? AppColors.white : AppColors.white,
                    ),
                    onPressed: () {
                      DatabaseHelper.updateMealStatus(
                              id: meal.id!,
                              status: meal.status == 'booked'
                                  ? locale.available
                                  : 'booked')
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(meal.status == 'booked'
                                ? 'Booked canceled'
                                : 'Meal booked')));
                        NavigationUtil.popScreen(context);
                        context.read<MealCubit>().fetchMeals();
                      });
                    },
                    child: Text(
                      meal.status == 'booked' ? locale.cancel : locale.book_now,
                      style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
