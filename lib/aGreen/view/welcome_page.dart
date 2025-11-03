import 'package:a_green/aGreen/models/user_model.dart';
import 'package:a_green/aGreen/view/register_agreen.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  // final UserModel user;
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffCBF3BB),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              //Image.asset
              SizedBox(height: 30),
              Text(
                'aGreen',
                style: TextStyle(fontSize: 30, color: Color(0xff98DBA5)),
              ),
              SizedBox(height: 5),
              Text(
                'Help you to get to know your green friends',
                style: TextStyle(fontSize: 15, color: Color(0xff55695A)),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterAgreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF98DBA5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Join now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
