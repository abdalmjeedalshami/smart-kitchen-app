import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth/auth_cubit.dart';
import '../../providers/auth/auth_state.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/navigation_util.dart';
import '../../utils/raleway_text.dart';
import '../../utils/responsive_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../login_screen.dart';


class DeleteAccountScreen extends StatefulWidget {

  const DeleteAccountScreen({super.key});
  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers to free resources
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
              NavigationUtil.navigateTo(context, screen: LoginScreen());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: responsive(context, 24),
                        right: responsive(context, 24),
                        top: responsive(context, 140)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo
                          SvgPicture.asset(
                            AppIcons.logo,
                            colorFilter: ColorFilter.mode(
                                Theme
                                    .of(context)
                                    .primaryColor, BlendMode.srcIn),
                          ),

                          SizedBox(height: responsive(context, 60)),

                          // Password TextField
                          customTextField(context,
                              controller: passwordController,
                              hintText: '********',
                              prefix: AppIcons.lock,
                              type: TextInputType.visiblePassword),

                          SizedBox(height: responsive(context, 10)),

                          // Forgot Password Text Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                },
                                child: RalewayText.medium(locale.forgot_password,
                                    color: AppColors.redColor)),
                          ),

                          // Delete Button
                          CustomButton(
                            text: locale.delete_my_account,
                            onPressed: () {
                              final password = passwordController.text;

                              context.read<AuthCubit>().deleteAccount(password);
                            },
                          ),
                        ])));
          },
        ));
  }
}
