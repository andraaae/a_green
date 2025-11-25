import 'dart:async';
import 'package:a_green/aGreen/bottom_navigation/buttom_navigation_agreen.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/view/login_agreen.dart';
import 'package:a_green/aGreen/view/login_firebase.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  // animasi titik
  int _activeDot = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _startDotAnimation();
    isLoginFunction();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
    });
  }

  // DOT-DOT-DOT ANIMATION
  void _startDotAnimation() {
    Timer.periodic(const Duration(milliseconds: 350), (timer) {
      if (!mounted) return;
      setState(() {
        _activeDot = (_activeDot + 1) % 3;
      });
    });
  }

  void isLoginFunction() async {
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      var isLogin = await PreferenceHandler.getLogin();
      if (!mounted) return;

      if (isLogin == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ButtomNavigationAgreen()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginFirebase()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCBF3BB),
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              SizedBox(
                width: 200,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/images/aGreen.jpg'),
                ),
              ),

              const SizedBox(height: 30),

              // DOT-DOT-DOT LOADING
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _activeDot == i ? 1.0 : 0.2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xff658C58),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),
              const Text(
                "Loading...",
                style: TextStyle(
                  color: Color(0xff658C58),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
