import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth/auth_cubit.dart';
import '../providers/auth/auth_state.dart';
import '../providers/home/home_cubit.dart';
import '../providers/main/main_cubit.dart';
import '../providers/main/main_state.dart';
import '../providers/meals/meal_provider.dart';
import '../services/database_helper.dart';
import '../utils/responsive_util.dart';

AppBar appBar(context) => AppBar(
      elevation: 0,
      leading: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          MainCubit mainCubit = context.read<MainCubit>();
          return IconButton(
            tooltip: 'toggle theme',
            onPressed: () {
              mainCubit.toggleTheme();
            },
            icon: Icon(mainCubit.isLightTheme
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined),
          );
        },
      ),
      actions: [
        BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            MainCubit mainCubit = context.read<MainCubit>();
            return IconButton(
              icon: const Icon(Icons.language),
              tooltip: AppLocalizations.of(context)!.email,
              onPressed: () {
                mainCubit.toggleLanguage();
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            BlocProvider.of<MealCubit>(context).deleteDatabaseFile();
          },
          tooltip: 'add some meals',
        ),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(right: responsive(context, 16)),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<HomeCubit>(context).changeSelectedIndex(3);
                },
                child: CircleAvatar(
                  backgroundImage: state is AuthImageUploaded
                      ? NetworkImage(context.read<AuthCubit>().profileImagePath)
                      : NetworkImage(context
                                  .read<AuthCubit>()
                                  .box
                                  .get('userImage') ??
                              'https://th.bing.com/th/id/OIP.iPvPGJG166ivZnAII4ZS8gHaHa?rs=1&pid=ImgDetMain')
                          as ImageProvider,
                  radius: 20,
                ),
              ),
            );
          },
        ),
      ],
    );
