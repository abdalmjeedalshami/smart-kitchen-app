import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meal_app_planner/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return _validateField(value);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('كلمة المرور وتأكيدها غير متطابقتين')),
        );
        return;
      }
      final Map<String, String> formData = {
        "first_name": _usernameController.text,
        "last_name": "test", // أو من حقل آخر
        "email": _emailController.text,
        "phone": "000000000", // أو من حقل آخر
        "gender": "ma", // أو من حقل آخر
        "birth_date": "2000-01-01", // أو من حقل آخر
        "password": _passwordController.text,
        "password_confirmation": _confirmPasswordController.text,
      };
      final result = await ApiService.registerUser(formData);
      print('REGISTER RESULT:');
      print(result);
      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        final token =
            result['data']['Token'] ??
            result['data']['Token:'] ??
            result['data']['token'];
        print('TOKEN (SignupScreen): ' + (token ?? 'NULL'));
        await prefs.setString('token', token);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  Image.asset('assets/famous.png', height: 290),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 65, 113),
                      ),
                    ),
                    const SizedBox(height: 175),
                    _buildFormField(
                      "User Name",
                      Icons.person,
                      _usernameController,
                      _validateField,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      "Email",
                      Icons.email,
                      _emailController,
                      _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      obscure: _obscurePassword,
                      toggle:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      icon: Icons.lock,
                      obscure: _obscureConfirmPassword,
                      toggle:
                          () => setState(
                            () =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                          ),
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: _submitForm,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 65, 113),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Already have an account?  ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 65, 113),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Log in here',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
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

  Widget _buildFormField(
    String label,
    IconData icon,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.black.withOpacity(1),
      child: TextFormField(
        controller: controller,
        cursorColor: const Color.fromARGB(255, 6, 65, 113),
        decoration: _buildInput(label, icon),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.black.withOpacity(1),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        cursorColor: const Color.fromARGB(255, 6, 65, 113),
        decoration: _buildInput(label, icon).copyWith(
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
            color: const Color.fromARGB(255, 6, 65, 113),
          ),
        ),
        validator: validator ?? _validateField,
      ),
    );
  }

  InputDecoration _buildInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 6, 65, 113)),
      filled: true,
      fillColor: const Color.fromARGB(255, 255, 250, 240),
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: const TextStyle(color: Colors.orange),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromARGB(255, 6, 65, 113)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.orange),
      ),
    );
  }
}
