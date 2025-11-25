import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/user_firebase.dart';
import 'package:a_green/aGreen/service/firebase.dart';
import 'package:a_green/aGreen/view/login_agreen.dart';
import 'package:a_green/aGreen/view/login_firebase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterFirebase extends StatefulWidget {
  const RegisterFirebase({super.key});
  static const id = "/register_RegisterFirebase";

  @override
  State<RegisterFirebase> createState() => _RegisterFirebaseState();
}

class _RegisterFirebaseState extends State<RegisterFirebase> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;
  UserFirebaseModel? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCBF3BB),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Register now', style: TextStyle(fontSize: 20)),

                const SizedBox(height: 29),

                // Username
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text('Username'),
                ),
                const SizedBox(height: 7),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'What do we call you?',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter username'
                      : null,
                ),

                const SizedBox(height: 15),

                // Email
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text('Email'),
                ),
                const SizedBox(height: 7),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Please input email',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.mail),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email cannot be empty';
                    if (!value.contains('@')) return 'Email is invalid';
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Phone
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Phone number'),
                ),
                const SizedBox(height: 7),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Please input phone number',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Phone number cannot be empty'
                      : null,
                ),

                const SizedBox(height: 15),

                // Password
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password'),
                ),
                const SizedBox(height: 7),
                TextFormField(
                  controller: passwordController,
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Please input password',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() => isVisible = !isVisible);
                      },
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password cannot be empty';
                    if (value.length < 7)
                      return 'Minimum password length 7 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffB3E2A7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Register'),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) {
                              Fluttertoast.showToast(
                                msg: "Please fill all fields correctly",
                              );
                              return;
                            }

                            setState(() => isLoading = true);

                            try {
                              final result = await FirebaseService.registerUser(
                                email: emailController.text.trim(),
                                username: nameController.text.trim(),
                                password: passwordController.text.trim(),
                                phone: phoneController.text.trim(),
                              );

                              setState(() {
                                user = result;
                                isLoading = false;
                              });

                              if (user?.uid != null) {
                                await PreferenceHandler.saveToken(user!.uid!);
                                Fluttertoast.showToast(
                                  msg: "Register successful",
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginFirebase(),
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() => isLoading = false);
                              Fluttertoast.showToast(msg: e.toString());
                            }
                          },
                        ),
                      ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginAgreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login here",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
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
    );
  }
}
