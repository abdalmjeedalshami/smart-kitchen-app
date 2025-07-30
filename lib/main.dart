import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:meal_app_planner/providers/auth/auth_cubit.dart';
import 'package:meal_app_planner/providers/home/home_cubit.dart';
import 'package:meal_app_planner/providers/main/main_cubit.dart';
import 'package:meal_app_planner/providers/main/main_state.dart';
import 'package:meal_app_planner/providers/meals/meal_provider.dart';
import 'package:meal_app_planner/screens/flash_screen.dart';
import 'package:meal_app_planner/services/auth_service.dart';
import 'package:meal_app_planner/services/database_helper.dart';
import 'package:meal_app_planner/utils/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('authBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => AuthCubit(AuthService())),
        BlocProvider(create: (_) => MealCubit(DatabaseHelper.instance)..fetchMeals()..addSampleMeals(DatabaseHelper.instance))
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          MainCubit mainCubit = context.read<MainCubit>();
          return MaterialApp(
            locale: mainCubit.currentLocale,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'Meal Planner',
            theme: mainCubit.isLightTheme ? AppTheme.lightTheme : AppTheme.darkTheme,
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
