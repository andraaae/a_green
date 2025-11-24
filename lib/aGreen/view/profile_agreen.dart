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
  bool isSounding = false;

  @override
  void initState() {
    super.initState();
    getData();
    loadNotificationStatus();
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
    String initials = parts.map((part) => part[0].toUpperCase()).take(2).join();
    return initials;
  }

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
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
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
          ),

          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () async {
                if (dataUser != null) {
                  UserModel updatedUser = UserModel(
                    id: dataUser!.id,
                    username: nameController.text,
                    email: emailController.text,
                    password: dataUser!.password,
                    phone: dataUser!.phone,
                    address: dataUser!.address,
                  );

                  await DbHelper.updateUser(updatedUser);
                  Navigator.pop(context);
                  await getData();

                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text("Success"),
                          content:
                              const Text("Your profile has been updated!"),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
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
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
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
                              color:
                                  isDark ? Colors.green[200] : const Color(0xff658C58),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.person,
                            size: 30,
                            color:
                                isDark ? Colors.green[200] : const Color(0xff658C58),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Profile Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  isDark ? Colors.green[200] : const Color(0xffB9D4AA),
                              child: initials.isNotEmpty
                                  ? Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.black : Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_outline,
                                      color: isDark ? Colors.black : Colors.white,
                                      size: 45,
                                    ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username.isNotEmpty ? username : "Guest",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    email.isNotEmpty ? email : "No email available",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.grey[400] : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: _showEditProfileDialog,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      foregroundColor: isDark
                                          ? Colors.green[200]
                                          : const Color(0xffA0C878),
                                    ),
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
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

                      _buildSettingCard(
                        isDark: isDark,
                        icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.sunny,
                        iconColor: themeProvider.isDarkMode
                            ? const Color(0xffB7B89F)
                            : const Color(0xffABE7B2),
                        title: 'Theme',
                        subtitle: themeProvider.isDarkMode
                            ? 'Dark Mode'
                            : 'Light Mode',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) => themeProvider.toggleTheme(value),
                          inactiveThumbColor: const Color(0xffA0C878),
                          activeTrackColor: const Color(0xffCBF3BB),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _buildSettingCard(
                        isDark: isDark,
                        icon: isSounding
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        iconColor: isSounding
                            ? const Color(0xffABE7B2)
                            : const Color(0xffB7B89F),
                        title: 'Notification',
                        subtitle: isSounding
                            ? "Notification's on"
                            : "Notification's off",
                        trailing: Switch(
                          value: isSounding,
                          onChanged: (value) => updateNotificationStatus(value),
                          inactiveThumbColor: const Color(0xffA0C878),
                          activeTrackColor: const Color(0xffCBF3BB),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Divider(
                        color: isDark ? Colors.green[900] : Colors.green.shade200,
                        thickness: 1,
                        height: 30,
                      ),

                      const SizedBox(height: 20),
                      _buildAboutCard(isDark, context),

                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            minimumSize: const Size(500, 30),
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SplashScreen(),
                              ),
                            );
                          },
                          child: const Text(
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
      width: double.infinity,
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
                    fontSize: 12,
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
          'Version 2.0.0',
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
