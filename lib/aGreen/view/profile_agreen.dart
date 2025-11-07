import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/user_model.dart';
import 'package:a_green/aGreen/view/about_agreen.dart';
import 'package:a_green/aGreen/view/splash_screen.dart';
import 'package:a_green/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileAgreen extends StatefulWidget {
  const ProfileAgreen({super.key});

  @override
  State<ProfileAgreen> createState() => _ProfileAgreenState();
}

class _ProfileAgreenState extends State<ProfileAgreen> {
  UserModel? dataUser;
  final int _selectedIndex = 0;
  bool isSounding = false; //notif
  bool isOn = false; //tema

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var id = await PreferenceHandler.getId();
    if (id != null) {
      UserModel? result = await DbHelper.getUser(id);

      setState(() {
        dataUser = result;
      });
    }
  }

  //inisial
  String getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(' ');
    String initials = parts.map((part) => part[0].toUpperCase()).take(2).join();
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      //backgroundColor: Color(0xffCBF3BB),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),

              //header
              Row(
                children: [
                  Text('Profile', style: TextStyle(fontSize: 19)),
                  SizedBox(width: 6),
                  Icon(Icons.person, color: Color(0xff777C6D)),
                ],
              ),

              SizedBox(height: 15),

              //profile card
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Color(0xffB9D4AA),
                        child: Text(
                          dataUser?.username ?? "",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataUser?.username ?? "",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Text(
                            dataUser?.email ?? "",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              Text('Setting', style: TextStyle(fontSize: 16)),
              SizedBox(height: 18),

              /// tema
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      themeProvider.isDarkMode ? Icons.dark_mode : Icons.sunny,
                      color: themeProvider.isDarkMode
                          ? Color(0xffB7B89F)
                          : Color(0xffABE7B2),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Theme',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            themeProvider.isDarkMode
                                ? 'Dark Mode'
                                : 'Light Mode',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                      inactiveThumbColor: Color(0xffA0C878),
                      activeTrackColor: Color(0xffCBF3BB),
                    ),
                  ],
                ),
              ),

              //notif
              SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      isSounding
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: isSounding ? Color(0xffABE7B2) : Color(0xffB7B89F),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notification',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            isSounding
                                ? "Notification's on"
                                : "Notification's off",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isSounding,
                      onChanged: (value) {
                        setState(() {
                          isSounding = value;
                          isSounding = value;
                        });
                      },
                      inactiveThumbColor: Color(0xffA0C878),
                      activeTrackColor: Color(0xffCBF3BB),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Divider(color: Colors.green.shade200, thickness: 1, height: 30),

              //  about aGreen
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    elevation: 0,
                    minimumSize: Size(double.infinity, 0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutAgreen()),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info, color: Color(0xffCBF3BB)),

                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'About aGreen',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    minimumSize: Size(500, 30),
                    side: BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.red, fontSize: 13),
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
