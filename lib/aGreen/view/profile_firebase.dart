import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/user_firebase.dart';
import 'package:a_green/aGreen/service/firebase.dart';
import 'package:a_green/aGreen/view/about_agreen.dart';
import 'package:a_green/aGreen/view/splash_screen.dart';
import 'package:a_green/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileFirebase extends StatefulWidget {
  const ProfileFirebase({super.key});

  @override
  State<ProfileFirebase> createState() => _ProfileFirebaseState();
}

class _ProfileFirebaseState extends State<ProfileFirebase> {
  UserFirebaseModel? dataUser;
  bool isSounding = false;

  @override
  void initState() {
    super.initState();
    getData();
    loadNotificationStatus();
  }

  // 🔥 Ambil data user dari Firestore
  Future<void> getData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await FirebaseService.getUserData(user.uid);

    if (!mounted) return;
    setState(() {
      dataUser = result;
    });
  }

  Future<void> loadNotificationStatus() async {
    bool status = await PreferenceHandler.getNotificationEnabled();
    setState(() {
      isSounding = status;
    });
  }

  Future<void> updateNotificationStatus(bool value) async {
    setState(() {
      isSounding = value;
    });
    await PreferenceHandler.setNotificationEnabled(value);
  }

  String getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(' ');
    return parts.map((e) => e[0].toUpperCase()).take(2).join();
  }

  // 🔥 Edit Profile (update Firestore)
  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(
      text: dataUser?.username ?? "",
    );
    final TextEditingController emailController = TextEditingController(
      text: dataUser?.email ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                await FirebaseService.updateUserData(user.uid, {
                  "username": nameController.text.trim(),
                  "email": emailController.text.trim(),
                  "updateAt": DateTime.now().toIso8601String(),
                });

                Navigator.pop(context);
                await getData();

                if (!mounted) return;

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: const Text("Success"),
                    content: const Text("Your profile has been updated!"),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffA0C878),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    String username = dataUser?.username ?? "";
    String email = dataUser?.email ?? "";
    String initials = getInitials(username);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.green[200]
                                  : const Color(0xff658C58),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.person,
                            size: 30,
                            color: isDark
                                ? Colors.green[200]
                                : const Color(0xff658C58),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // PROFILE CARD
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: isDark
                                  ? Colors.green[200]
                                  : const Color(0xffB9D4AA),
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username.isEmpty ? "Guest" : username,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    email.isEmpty
                                        ? "No email available"
                                        : email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: _showEditProfileDialog,
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // THEME CARD
                      _buildSettingCard(
                        isDark: isDark,
                        icon: isDark ? Icons.dark_mode : Icons.sunny,
                        iconColor: isDark
                            ? const Color(0xffB7B89F)
                            : const Color(0xffABE7B2),
                        title: 'Theme',
                        subtitle: isDark ? 'Dark Mode' : 'Light Mode',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) =>
                              themeProvider.toggleTheme(value),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // NOTIFICATION CARD
                      // _buildSettingCard(
                      //   isDark: isDark,
                      //   icon: isSounding
                      //       ? Icons.notifications_active
                      //       : Icons.notifications_off,
                      //   iconColor:
                      //       isSounding ? const Color(0xffABE7B2) : const Color(0xffB7B89F),
                      //   title: 'Notification',
                      //   subtitle: isSounding
                      //       ? "Notification's on"
                      //       : "Notification's off",
                      //   trailing: Switch(
                      //     value: isSounding,
                      //     onChanged: updateNotificationStatus,
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      Divider(
                        color: isDark
                            ? Colors.green[900]
                            : Colors.green.shade200,
                      ),

                      const SizedBox(height: 20),

                      _buildAboutCard(isDark, context),

                      const SizedBox(height: 40),

                      // LOGOUT
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            minimumSize: const Size(500, 30),
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () async {
                            await PreferenceHandler.saveLogin(false);
                            await FirebaseAuth.instance.signOut();

                            if (!mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SplashScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildAboutCard(bool isDark, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          Icons.info,
          color: isDark ? Colors.green[200] : const Color(0xffCBF3BB),
        ),
        title: Text(
          'About aGreen',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          'Version 1.0.0',
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutAgreen()),
          );
        },
      ),
    );
  }
}
