import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'signup_screen.dart';
import 'home_page.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateField(value) {
    if (value!.isEmpty) return 'This field is required';
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
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
                    Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 65, 113),
                      ),
                    ),
                    const SizedBox(height: 200),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      shadowColor: Colors.black.withOpacity(1),
                      child: TextFormField(
                        controller: _emailController,
                        cursorColor: Color.fromARGB(255, 6, 65, 113),
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInput("Email", Icons.email),
                        validator: _validateField,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      shadowColor: Colors.black.withOpacity(1),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        cursorColor: Color.fromARGB(255, 6, 65, 113),
                        decoration: _buildInput("Password", Icons.lock),
                        validator: _validateField,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        // onPressed: () => _submitForm(context),
                        onPressed: (){Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );},
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 65, 113),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'First time on the app?  ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 6, 65, 113),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign up here',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => SignupScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          final emailController = TextEditingController();
                          await showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('استعادة كلمة المرور'),
                                  content: TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'البريد الإلكتروني',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('إلغاء'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final email =
                                            emailController.text.trim();
                                        if (email.isEmpty) return;
                                        final result =
                                            await ApiService.forgotPassword(
                                              email,
                                            );
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['success']
                                                  ? 'تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني'
                                                  : (result['message'] ??
                                                      'فشل في إرسال البريد'),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('إرسال'),
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: const Text('نسيت كلمة المرور؟'),
                      ),
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

  InputDecoration _buildInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color.fromARGB(255, 6, 65, 113)),
      filled: true,
      fillColor: Color.fromARGB(255, 255, 250, 240),
      labelStyle: TextStyle(color: Colors.grey),
      floatingLabelStyle: TextStyle(color: Colors.orange),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color.fromARGB(255, 6, 65, 113)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.orange),
      ),
    );
  }
}
