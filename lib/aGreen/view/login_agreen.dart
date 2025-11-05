import 'package:a_green/aGreen/bottom_navigation/buttom_navigation_agreen.dart';
import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/models/user_model.dart';
import 'package:a_green/aGreen/view/home_page_agreen.dart';
import 'package:a_green/aGreen/view/register_agreen.dart';
import 'package:flutter/material.dart';

class LoginAgreen extends StatefulWidget {
  const LoginAgreen({super.key});

  @override
  State<LoginAgreen> createState() => _LoginAgreenState();
}

class _LoginAgreenState extends State<LoginAgreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isVisible = false;
  bool isButtonEnable = false;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void checkFormField() {
    setState(() {
      isButtonEnable =
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCBF3BB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ===== EMAIL FIELD =====
                  const Text('Email'),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'yourname@gmail.com',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.mail),
                    ),
                    onChanged: (_) => checkFormField(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      } else if (!value.contains('@')) {
                        return 'Email must contain @';
                      } else if (!RegExp(
                        r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
                      ).hasMatch(value)) {
                        return 'Email format is invalid';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ===== PHONE FIELD =====
                  const Text('Phone Number'),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '08123456789',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => checkFormField(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number cannot be empty';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ===== PASSWORD FIELD =====
                  const Text('Password'),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Please input password',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                    ),
                    onChanged: (_) => checkFormField(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (value.length < 7) {
                        return 'Minimum password length is 7 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // ===== LOGIN BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnable
                            ? const Color(0xffB3E2A7)
                            : Color(0xffB3E2A7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final user = await DbHelper.loginUser(
                          email: email,
                          password: password,
                        );
                        if (user != null) {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => HomePageAgreen(),
                          //   ),
                          // );
                          // print('Register Success for ${emailController.text}');

                          //pindah ke halamamn home
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ButtomNavigationAgreen(),
                            ),
                          );
                        }
                      },

                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xffFDFAF6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ===== REGISTER LINK =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RegisterAgreen(), //sampe sini
                            ),
                          );
                          print('Register now');
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xffADD899),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFADD899),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
