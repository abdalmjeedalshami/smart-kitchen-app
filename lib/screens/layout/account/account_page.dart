import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/auth/auth_cubit.dart';
import '../../../providers/auth/auth_state.dart';
import '../../../utils/colors.dart';
import '../../../utils/icons.dart';
import '../../../utils/navigation_util.dart';
import '../../../utils/raleway_text.dart';
import '../../../utils/responsive_util.dart';
import '../../../utils/show_dialog_util.dart';
import '../../../widgets/profile_field.dart';
import '../../auth/delete_account_screen.dart';
import '../../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker picker = ImagePicker();
  File? image; // Stores the selected image

  void _editFullName() {}

  void _editEmail() {}

  void _editPhone() {}

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.user;
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (!context.mounted) return;

          if (state is AuthImageUploaded || state is GetProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Profile image updated successfully')),
            );
          } else if (state is GetProfileFailure || state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('state.error')),
            );
          } else if (state is AuthSuccess) {
            NavigationUtil.navigateTo(context, screen: const LoginScreen());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is GetProfileLoading || state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: responsive(context, 24),
              vertical: responsive(context, 90),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Photo
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: state is AuthImageUploaded
                          ? NetworkImage(authCubit.profileImagePath)
                          : NetworkImage(context
                                      .read<AuthCubit>()
                                      .box
                                      .get('userImage') ??
                                  'https://th.bing.com/th/id/OIP.iPvPGJG166ivZnAII4ZS8gHaHa?rs=1&pid=ImgDetMain')
                              as ImageProvider,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final XFile? pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          setState(() {
                            image = File(pickedFile.path);
                          });

                          authCubit.uploadProfileImage(pickedFile.path);
                        } else {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No image selected")),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: SvgPicture.asset(AppIcons.change),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: responsive(context, 16)),

                // Display user name
                RalewayText.medium(
                  '${user?['first_name']} ${user?['last_name'] ?? ''}',
                  fontSize: responsive(context, 15),
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: responsive(context, 30)),

                // Editable fields
                ProfileField(
                  iconPath: AppIcons.person,
                  label: locale.full_name,
                  value:
                      '${user?['first_name'] ?? ''} ${user?['last_name'] ?? ''}',
                  onEdit: _editFullName,
                ),
                SizedBox(height: responsive(context, 16)),

                ProfileField(
                  iconPath: AppIcons.email,
                  label: locale.email,
                  value: user?['email'] ?? 'No email',
                  onEdit: _editEmail,
                ),
                SizedBox(height: responsive(context, 16)),

                ProfileField(
                  iconPath: AppIcons.phone,
                  label: locale.phone_number,
                  value: user?['phone'] ?? '+9639999999',
                  onEdit: _editPhone,
                ),
                SizedBox(height: responsive(context, 180)),

                // Logout button
                GestureDetector(
                  onTap: () {
                    showLogoutDialog(context, onLogoutPressed: () {
                      /// ToDo: Delete this line
                      NavigationUtil.navigateTo(context, screen: LoginScreen());

                      /// ToDo: We need this
                      authCubit.logout();
                    });
                  },
                  child: RalewayText.bold(
                    locale.logout,
                    color: AppColors.redColor,
                    fontSize: responsive(context, 16),
                  ),
                ),

                SizedBox(height: responsive(context, 50)),

                // Delete account button
                GestureDetector(
                  onTap: () {
                    NavigationUtil.navigateTo(context,
                        screen: const DeleteAccountScreen(), withRoute: true);
                  },
                  child: RalewayText.bold(
                    locale.delete_my_account,
                    color: AppColors.redColor,
                    fontSize: responsive(context, 10),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
