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

  // 🆕 Dialog untuk edit profil (sudah termasuk konfirmasi sukses)
  void _showEditProfileDialog() {
    final TextEditingController nameController =
        TextEditingController(text: dataUser?.username ?? "");
    final TextEditingController emailController =
        TextEditingController(text: dataUser?.email ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Edit Profile"),
          content: Column(
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
                  Navigator.pop(context); // tutup dialog edit
                  await getData();

                  // 🆕 Dialog konfirmasi sukses
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
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
                        );
                      },
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffA0C878),
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

    String username = dataUser?.username ?? "";
    String email = dataUser?.email ?? "";
    String initials = getInitials(username);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Row(
                children: [
                  Text('Profile', style: TextStyle(fontSize: 19)),
                  SizedBox(width: 6),
                  Icon(Icons.person, color: Color(0xff777C6D)),
                ],
              ),
              const SizedBox(height: 15),

              // Profile card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
  radius: 45,
  backgroundColor: const Color(0xffB9D4AA),
  child: initials.isNotEmpty
      ? Text(
          initials,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode
                ? Colors.white   // 🌙 dark mode → putih
                : Colors.black,  // 🌞 light mode → hitam
          ),
        )
      : Icon(
          Icons.person_outline,
          color: themeProvider.isDarkMode
              ? Colors.white
              : Colors.black,
          size: 45,
        ),
),

                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  username.isNotEmpty ? username : "Guest",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              TextButton(
                                onPressed: _showEditProfileDialog,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: const Color(0xffA0C878),
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
                          Text(
                            email.isNotEmpty ? email : "No email available",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text('Setting', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 18),

              // Theme switch
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.sunny,
                      color: themeProvider.isDarkMode
                          ? const Color(0xffB7B89F)
                          : const Color(0xffABE7B2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
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
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) => themeProvider.toggleTheme(value),
                      inactiveThumbColor: const Color(0xffA0C878),
                      activeTrackColor: const Color(0xffCBF3BB),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Notification switch
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      isSounding
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: isSounding
                          ? const Color(0xffABE7B2)
                          : const Color(0xffB7B89F),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
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
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isSounding,
                      onChanged: (value) => updateNotificationStatus(value),
                      inactiveThumbColor: const Color(0xffA0C878),
                      activeTrackColor: const Color(0xffCBF3BB),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              Divider(color: Colors.green.shade200, thickness: 1, height: 30),

              // About section
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutAgreen()),
                    );
                  },
                  child: const Row(
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

              const SizedBox(height: 30),

              // Logout
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
                          builder: (context) => const SplashScreen()),
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
  }
}
