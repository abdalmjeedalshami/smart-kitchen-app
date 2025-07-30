import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_app_planner/utils/theme/app_theme.dart';
import 'package:meal_app_planner/widgets/poppins_text.dart';
import '../models/meal_model.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';
import '../utils/responsive_util.dart';

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({
    super.key,
    required this.meal
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsive(context, 250),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            // Image and Overlay with Opacity
            Image.asset(
              meal.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: responsive(context, 120),
              color: AppColors.charcoalGray.withOpacity(.4),
              child: Padding(
                padding: EdgeInsets.only(
                    left: responsive(context, 12),
                    top: responsive(context, 12),
                    right: responsive(context, 5),
                    bottom: responsive(context, 12)),
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
                              fontSize: responsive(context, 18),
                              color: AppColors.white),
                        ),
                        // Stars Rating
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < meal.rate ? Icons.star : Icons.star_border,
                              color: Colors.orange,
                              size: responsive(context, 8),
                            );
                          }),
                        ),
                      ],
                    ),
                    // Price
                    PoppinsText.medium('${meal.requiredTime.toStringAsFixed(2)} min',
                        fontSize: responsive(context, 15),
                        color: AppColors.white),
                    // Features Icons & Available
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // TV
                            Padding(
                              padding: EdgeInsets.only(
                                  right: responsive(context, 8)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                  Theme.of(context).featureIconBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(AppIcons.eco,
                                      width: 10,
                                      height: 10,
                                      colorFilter: ColorFilter.mode(
                                          meal.vegetarianFriendly
                                              ? Colors.blue
                                              : Colors.grey,
                                          BlendMode.srcIn)),
                                ),
                              ),
                            ),
                            // Shower
                            Padding(
                              padding: EdgeInsets.only(
                                  right: responsive(context, 8)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                  Theme.of(context).featureIconBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(AppIcons.kitchen,
                                      width: 10,
                                      height: 10,
                                      colorFilter: ColorFilter.mode(
                                          meal.glutenFree
                                              ? Colors.blue
                                              : Colors.grey,
                                          BlendMode.srcIn)),
                                ),
                              ),
                            ),
                            // wifi
                            Padding(
                              padding: EdgeInsets.only(
                                  right: responsive(context, 8)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                  Theme.of(context).featureIconBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(AppIcons.bedtime,
                                      width: 10,
                                      height: 10,
                                      colorFilter: ColorFilter.mode(
                                          meal.allergySafe
                                              ? Colors.blue
                                              : Colors.grey,
                                          BlendMode.srcIn)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        PoppinsText.semiBold(meal.available ? 'Available' : 'Unavailable',
                            fontSize: responsive(context, 10),
                            color: meal.available ? AppColors.white : AppColors.redColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
