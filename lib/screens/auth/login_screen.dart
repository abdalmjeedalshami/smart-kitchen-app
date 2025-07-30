import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meal_app_planner/screens/layout/home_layout.dart';
import '../../providers/auth/auth_cubit.dart';
import '../../providers/auth/auth_state.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/responsive_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/raleway_text.dart';
import '../../widgets/social_login_button.dart';
import 'package:meal_app_planner/screens/home_page.dart';
import '../../providers/home/home_cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/navigation_util.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool rememberMe = false;

  @override
  void dispose() {
    // Dispose of the controllers to free resources
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Default state for rememberMe checkbox
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.read<AuthCubit>().getProfile();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
        if (state is GetProfileSuccess) {
          context.read<HomeCubit>().currentIndex = 0;
          NavigationUtil.navigateTo(context, screen: HomeLayout());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading || state is GetProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(
                    left: responsive(context, 24),
                    right: responsive(context, 24),
                    top: responsive(context, 50)),
                child: Column(
                  children: [
                    // Logo
                    SvgPicture.asset(
                      height: responsive(context, 150),
                      AppIcons.logo,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: responsive(context, 60)),

                            ValidatedFieldWrapper(
                              hintText: locale.email,
                              prefix: AppIcons.email,
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email required';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                    .hasMatch(value)) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),

                            // Password TextField
                            customTextField(
                              context,
                              controller: passwordController,
                              hintText: '********',
                              prefix: AppIcons.lock,
                              type: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return 'Password must contain at least one uppercase letter';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'Password must contain at least one number';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: responsive(context, 10)),

                            // Forgot Password Text Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {
                                    NavigationUtil.navigateTo(context,
                                        screen: const HomePage(),
                                        withRoute: true);
                                  },
                                  child: RalewayText.medium(locale.forgot_password,
                                      color: AppColors.redColor)),
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  activeColor: AppColors.primary,
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value!;
                                    });
                                  },
                                ),
                                Text(locale.remember_me),
                              ],
                            ),

                            SizedBox(height: responsive(context, 10)),

                            /// Sign In Button
                            CustomButton(
                              text: locale.login,
                              onPressed: () {
                                NavigationUtil.navigateTo(context, screen: HomeLayout()); /// Todo: Delete this line
                                // if (formKey.currentState!.validate()) {
                                //   final email = emailController.text;
                                //   final password = passwordController.text;
                                //
                                //   context
                                //       .read<AuthCubit>()
                                //       .login(email, password);
                                // } else {}
                              },
                              // goTo: HomeLayout(),
                            ),

                            SizedBox(height: responsive(context, 10)),

                            // Register Text Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {
                                    NavigationUtil.navigateTo(context,
                                        screen: const HomePage(), /// Todo: Should be Sign up screen instead.
                                        withRoute: true);
                                  },
                                  child: RalewayText.bold(locale.register_now)),
                            ),

                            SizedBox(height: responsive(context, 35)),

                            // Or Text
                            RalewayText.semiBold(locale.or),

                            SizedBox(height: responsive(context, 35)),

                            // Apple Sign-In Button
                            socialLoginButton(context,
                                text: locale.continue_with_apple,
                                iconPath: AppIcons.apple,
                                onPressed: () {}),

                            SizedBox(height: responsive(context, 20)),

                            socialLoginButton(context,
                                text: locale.continue_with_google,
                                iconPath: AppIcons.google,
                                onPressed: () {}),
                            SizedBox(height: responsive(context, 20)),

                          ]),
                    ),
                  ],
                )));
      },
    ));
  }
}
