import 'package:a_green/aGreen/bottom_navigation/buttom_navigation_agreen.dart';
import 'package:a_green/aGreen/database/preference_handler_firebase.dart';
import 'package:a_green/aGreen/service/firebase.dart';
import 'package:a_green/aGreen/view/register_firebase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginFirebase extends StatefulWidget {
  const LoginFirebase({super.key});

  @override
  State<LoginFirebase> createState() => _LoginFirebaseState();
}

class _LoginFirebaseState extends State<LoginFirebase> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCBF3BB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "Welcome back!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL FIELD
                const Text("Email"),
                const SizedBox(height: 7),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Please input email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.mail),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be empty";
                    }
                    if (!value.contains("@")) {
                      return "Email must contain @";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PASSWORD FIELD
                const Text("Password"),
                const SizedBox(height: 7),
                TextFormField(
                  controller: passwordController,
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Please input password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => isVisible = !isVisible);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password cannot be empty";
                    }
                    if (value.length < 7) {
                      return "Minimum 7 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB3E2A7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      setState(() => isLoading = true);

                      try {
                        // LOGIN FIREBASE
                        final user = await FirebaseService.loginUser(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        if (mounted) {
                          setState(() => isLoading = false);
                        }

                        if (user == null) {
                          Fluttertoast.showToast(
                            msg: "Email or password is wrong",
                          );
                          return;
                        }


                        await PreferenceHandlerFirebase.saveUid(user.uid ?? "");

                        // SAVE STATUS LOGIN
                        await PreferenceHandlerFirebase.saveLogin(true);

                        Fluttertoast.showToast(msg: "Login success!");

                        if (!mounted) return;

                        // PINDAH HALAMAN
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ButtomNavigationAgreen(),
                          ),
                        );
                      } catch (e) {
                        if (mounted) {
                          setState(() => isLoading = false);
                        }
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterFirebase(),
                          ),
                        );
                      },
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xffADD899),
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
