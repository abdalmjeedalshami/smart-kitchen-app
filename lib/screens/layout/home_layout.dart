import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_app_planner/utils/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/home/home_cubit.dart';
import '../../providers/home/home_state.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/responsive_util.dart';
import 'account/account_page.dart';
import 'home/home_screen.dart';
import 'meals/meals_page.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  final List<Widget> screens = [
    HomeScreen(),
    HomeScreen(),
    const MealsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        HomeCubit homeCubit = context.read<HomeCubit>();
        return Scaffold(
            body: screens[homeCubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: homeCubit.currentIndex,
              onTap: (newIndex) {
                homeCubit.changeSelectedIndex(newIndex);
              },
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: responsive(context, 10),
                  fontWeight: FontWeight.w500),
              unselectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: responsive(context, 10),
                  fontWeight: FontWeight.w500),
              selectedItemColor: AppColors.primary,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(AppIcons.home,
                      colorFilter: ColorFilter.mode(
                          homeCubit.currentIndex == 0
                              ? AppColors.primary
                              : Theme.of(context).unselectedItemColor,
                          BlendMode.srcIn)),
                  label: locale.home,
                  tooltip: locale.home
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(AppIcons.booking,
                      colorFilter: ColorFilter.mode(
                          homeCubit.currentIndex == 1
                              ? AppColors.primary
                              : Theme.of(context).unselectedItemColor,
                          BlendMode.srcIn)),
                  label: locale.booking,
                  tooltip: locale.booking
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(AppIcons.meals,
                      colorFilter: ColorFilter.mode(
                          homeCubit.currentIndex == 2
                              ? AppColors.primary
                              : Theme.of(context).unselectedItemColor,
                          BlendMode.srcIn)),
                  label: locale.meals,
                  tooltip: locale.meals
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(AppIcons.person,
                      colorFilter: ColorFilter.mode(
                          homeCubit.currentIndex == 3
                              ? AppColors.primary
                              : Theme.of(context).unselectedItemColor,
                          BlendMode.srcIn)),
                  label: locale.account,
                  tooltip: locale.account
                )
              ],
            ));
      },
    );
  }
}
