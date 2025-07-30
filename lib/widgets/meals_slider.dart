import 'package:flutter/material.dart';
import 'package:meal_app_planner/widgets/meal_card.dart';
import '../models/meal_model.dart';
import '../screens/meal_page/meal_page.dart';
import '../utils/navigation_util.dart';
import '../utils/responsive_util.dart';

Widget mealsSlider(context,
        {required List<Meal> meals, ScrollController? controller}) =>
    SizedBox(
      height: responsive(context, 350),
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return Padding(
            padding: index == 0
                ? EdgeInsets.only(
                    left: responsive(context, 16),
                    right: responsive(context, 10))
                : EdgeInsets.only(right: responsive(context, 10)),
            child: GestureDetector(
                onTap: () {
                  NavigationUtil.navigateTo(context,
                      screen: MealPage(meal: meal), withRoute: true);
                },
                child: MealCard(meal: meal)),
          );
        },
      ),
    );
